# Project Rules

## File Organization

- Put generated files, temp files, and AI artifacts in `.ai/` directory
- Clear separation: `src/` for code, `tests/` for testing, `docs/` for documentation

## Response Behavior

- **Default to conceptual responses** - if I don't explicitly tell you to write code, don't. Instead, give me a conceptual response with at most a high-level example in code.
- **Show your reasoning** - for complex decisions, briefly explain your thinking before the solution
- **One change at a time** - when refactoring or fixing issues, focus on one logical change per response unless I ask for multiple

## Code Generation

- **Context first** - understand the existing codebase patterns before generating new code
- **Coding style** - always retrieve `coding-{language}` skill before writing code (e.g., `coding-python`, `coding-rust`) unless already retrieved this conversation
- **Match the environment** - use the same libraries, patterns, and conventions already present
- **Validate assumptions** - if unclear about requirements or constraints, ask before implementing
- **Real examples over placeholders** - avoid `# TODO`, `# implementation here`, or placeholder comments

## Anti-patterns

- Don't apologize or explain why you can/can't do something unless I ask
- Don't add verbose preambles like "I'll help you with..." - just do it
- Don't wrap obvious code in unnecessary functions or abstractions
- Don't explain what standard library functions do
