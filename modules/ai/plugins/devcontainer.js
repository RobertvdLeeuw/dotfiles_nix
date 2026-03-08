import { tool } from "@opencode-ai/plugin/tool"
import { existsSync } from "fs"
import { resolve, dirname } from "path"

/**
 * Simple devcontainer integration for opencode
 * Uses existing devcontainers.nvim instance - no complex workspace management
 */

// Find .devcontainer directory walking up from cwd
function findDevcontainerDir(startPath) {
  let current = resolve(startPath)
  const root = "/"

  while (current !== root) {
    const devcontainerPath = resolve(current, ".devcontainer")
    if (existsSync(devcontainerPath)) {
      return current
    }
    current = dirname(current)
  }

  return null
}

// Build devcontainer exec command
function buildExecCommand(workspaceDir, command) {
  // Use same format as devcontainers.nvim CLI
  return `devcontainer exec --workspace-folder ${JSON.stringify(workspaceDir)} -- ${command}`
}

// Check if command should run on host (not in container)
function shouldRunOnHost(command) {
  const trimmed = command.trim()

  // Escape hatch: HOST: prefix
  if (/^HOST:\s*/i.test(trimmed)) {
    return "escape"
  }

  // Commands that should always run on host
  const hostCommands = [
    /^devcontainer\s/,        // devcontainer CLI itself
    /^docker\s/,              // docker commands
    /^git\s+clone\s/,         // git clone (creates new repos)
    /^npm\s+install\s+-g/,    // global npm installs
    /^curl.*\|\s*bash/,       // pipe to bash installers
  ]

  return hostCommands.some(pattern => pattern.test(trimmed))
}

export const devcontainers = async ({ client }) => {
  return {
    // Intercept bash commands
    "tool.execute.before": async (input, output) => {
      // Only intercept bash commands
      if (input.tool !== "bash") return

      const command = output.args?.command?.trim()
      if (!command) return

      // Check for HOST: escape hatch
      const hostCheck = shouldRunOnHost(command)
      if (hostCheck === "escape") {
        output.args.command = command.replace(/^HOST:\s*/i, "")
        return
      }

      // Check if command should run on host
      if (hostCheck) return

      // Find devcontainer workspace
      const workdir = output.args?.workdir || process.cwd()
      const workspaceDir = findDevcontainerDir(workdir)

      if (!workspaceDir) {
        // No devcontainer found - run normally
        return
      }

      // Wrap with devcontainer exec
      output.args.command = buildExecCommand(workspaceDir, command)
    }
  }
}

export default devcontainers
