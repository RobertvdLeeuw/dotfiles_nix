{
  pkgs,
  lib,
  ...
}:
{
  settings.vim = {
    # CodeCompanion Chat Persistence (Inline Version)
    # Auto-saves marked chats and restores them on startup
    # Usage: Press <A-s> in any chat buffer to toggle saving
    luaConfigPost = /* lua */ ''
      do
      	local M = {}

      	-- ============================================================================
      	-- CONFIGURATION (edit these if needed)
      	-- ============================================================================

      	local config = {
      		save_dir = ".ai/chats", -- Where to save (relative to project root)
      		visual_indicator = true, -- Show [SAVED] in buffer name
      		toggle_key = "<A-s>", -- Hotkey for toggling
      		auto_restore = true, -- Auto-restore on startup
      	}

      	-- ============================================================================
      	-- STATE
      	-- ============================================================================

      	local marked_chats = {}

      	-- ============================================================================
      	-- HELPERS
      	-- ============================================================================

      	local function find_ai_dir()
      		local cwd = vim.fn.getcwd()
      		local path = cwd

      		while path ~= "/" do
      			local ai_path = path .. "/.ai"
      			if vim.fn.isdirectory(ai_path) == 1 then
      				return ai_path
      			end

      			local parent = vim.fn.fnamemodify(path, ":h")
      			if parent == path then
      				break
      			end
      			path = parent
      		end

      		return nil
      	end

      	local function find_project_root()
      		local markers = {
      			".git",
      			"pyproject.toml",
      			"Cargo.toml",
      			"package.json",
      			"go.mod",
      			"pom.xml",
      			"build.gradle",
      			"Makefile",
      			"flake.nix",
      		}

      		local cwd = vim.fn.getcwd()
      		local path = cwd

      		while path ~= "/" do
      			for _, marker in ipairs(markers) do
      				local marker_path = path .. "/" .. marker
      				if vim.fn.filereadable(marker_path) == 1 or vim.fn.isdirectory(marker_path) == 1 then
      					return path
      				end
      			end

      			local parent = vim.fn.fnamemodify(path, ":h")
      			if parent == path then
      				break
      			end
      			path = parent
      		end

      		return nil
      	end

      	local function get_project_root()
      		local ai_dir = find_ai_dir()

      		if ai_dir then
      			return vim.fn.fnamemodify(ai_dir, ":h")
      		else
      			local project_root = find_project_root()

      			if project_root then
      				local new_ai_dir = project_root .. "/.ai"
      				vim.fn.mkdir(new_ai_dir, "p")
      				vim.notify(string.format("Created new .ai/ cache at %s", new_ai_dir), vim.log.levels.INFO)
      				return project_root
      			else
      				local cwd = vim.fn.getcwd()
      				local new_ai_dir = cwd .. "/.ai"
      				vim.fn.mkdir(new_ai_dir, "p")
      				vim.notify(string.format("Created new .ai/ cache at %s", new_ai_dir), vim.log.levels.INFO)
      				return cwd
      			end
      		end
      	end

      	local function get_chat_dir()
      		return vim.fn.join({ get_project_root(), config.save_dir }, "/")
      	end

      	local function ensure_chat_dir()
      		local dir = get_chat_dir()
      		vim.fn.mkdir(dir, "p")
      		return dir
      	end

      	local function get_chat_filepath(chat)
      		local dir = ensure_chat_dir()
      		local filename = (chat.title or string.format("chat_%d", chat.id)):gsub("[^%w_-]", "_")
      		return string.format("%s/%s.lua", dir, filename)
      	end

      	local function update_buffer_name(chat)
      		if not config.visual_indicator then
      			return
      		end

      		local base_name = chat.title or string.format("[CodeCompanion] %d", chat.bufnr)
      		local new_name

      		if marked_chats[chat.id] then
      			new_name = base_name .. " [SAVED]"
      		else
      			new_name = base_name:gsub("%s*%[SAVED%]$", "")
      		end

      		pcall(vim.api.nvim_buf_set_name, chat.bufnr, new_name)
      	end

      	-- Check if directory is empty (no files or subdirectories)
      	local function is_dir_empty(dir)
      		if vim.fn.isdirectory(dir) == 0 then
      			return true
      		end

      		local entries = vim.fn.glob(dir .. "/*", false, true)
      		return #entries == 0
      	end

      	-- Clean up .ai/ directory if it's empty after deleting last chat
      	local function cleanup_ai_dir_if_empty()
      		local ai_dir = find_ai_dir()
      		if not ai_dir then
      			return
      		end

      		local chats_dir = ai_dir .. "/chats"

      		-- Check if chats/ is empty
      		if not is_dir_empty(chats_dir) then
      			return
      		end

      		-- Check if .ai/ only contains the empty chats/ directory
      		local ai_entries = vim.fn.glob(ai_dir .. "/*", false, true)
      		local has_other_content = false

      		for _, entry in ipairs(ai_entries) do
      			local basename = vim.fn.fnamemodify(entry, ":t")
      			if basename ~= "chats" then
      				has_other_content = true
      				break
      			end
      		end

      		-- If .ai/ only has chats/ and chats/ is empty, remove everything
      		if not has_other_content then
      			-- Remove chats/ first
      			vim.fn.delete(chats_dir, "d")
      			-- Then remove .ai/
      			vim.fn.delete(ai_dir, "d")
      			vim.notify("Cleaned up empty .ai/ directory", vim.log.levels.INFO)
      		end
      	end

      	-- ============================================================================
      	-- SAVE/DELETE
      	-- ============================================================================

      	local function save_chat_to_disk(chat)
      		local data = {
      			title = chat.title,
      			id = chat.id,
      			messages = vim.tbl_map(function(msg)
      				return {
      					role = msg.role,
      					content = msg.content,
      				}
      			end, chat.messages),
      			adapter = chat.adapter.name,
      			saved_at = os.date("%Y-%m-%d %H:%M:%S"),
      		}

      		local filepath = get_chat_filepath(chat)
      		local file = io.open(filepath, "w")
      		if file then
      			file:write("return " .. vim.inspect(data))
      			file:close()
      			return true
      		end
      		return false
      	end

      	local function delete_chat_file(chat)
      		local filepath = get_chat_filepath(chat)
      		if vim.fn.filereadable(filepath) == 1 then
      			vim.fn.delete(filepath)
      			-- After deleting, check if we should clean up .ai/
      			cleanup_ai_dir_if_empty()
      			return true
      		end
      		return false
      	end

      	-- ============================================================================
      	-- AUTO-SAVE
      	-- ============================================================================

      	local function setup_autosave(chat)
      		local aug = string.format("CodeCompanionChatPersistence_%d", chat.id)

      		vim.api.nvim_create_augroup(aug, { clear = true })

      		vim.api.nvim_create_autocmd({ "BufWritePost", "BufLeave" }, {
      			group = aug,
      			buffer = chat.bufnr,
      			callback = function()
      				if marked_chats[chat.id] then
      					save_chat_to_disk(chat)
      				end
      			end,
      		})

      		vim.api.nvim_create_autocmd("User", {
      			group = aug,
      			pattern = "CodeCompanionChatDone",
      			callback = function(args)
      				if args.data and args.data.id == chat.id and marked_chats[chat.id] then
      					save_chat_to_disk(chat)
      				end
      			end,
      		})
      	end

      	local function remove_autosave(chat)
      		local aug = string.format("CodeCompanionChatPersistence_%d", chat.id)
      		pcall(vim.api.nvim_del_augroup_by_name, aug)
      	end

      	-- ============================================================================
      	-- PUBLIC API
      	-- ============================================================================

      	function M.toggle_save(chat)
      		if not chat then
      			vim.notify("No chat found", vim.log.levels.WARN)
      			return
      		end

      		if marked_chats[chat.id] then
      			-- Unmark
      			marked_chats[chat.id] = nil
      			remove_autosave(chat)
      			delete_chat_file(chat)
      			update_buffer_name(chat)
      			vim.notify("Chat unmarked for saving", vim.log.levels.INFO)
      		else
      			-- Mark
      			marked_chats[chat.id] = true
      			setup_autosave(chat)

      			if save_chat_to_disk(chat) then
      				update_buffer_name(chat)
      				vim.notify("Chat marked for saving", vim.log.levels.INFO)
      			else
      				vim.notify("Failed to save chat", vim.log.levels.ERROR)
      				marked_chats[chat.id] = nil
      			end
      		end
      	end

      	function M.is_marked(chat)
      		return marked_chats[chat.id] or false
      	end

      	function M.restore_chat(filepath)
      		local ok, data = pcall(dofile, filepath)
      		if not ok then
      			return nil
      		end

      		local codecompanion = require("codecompanion")
      		local chat = codecompanion.chat({
      			messages = data.messages,
      			title = data.title,
      			stop_context_insertion = true,
      		})

      		if chat then
      			marked_chats[chat.id] = true
      			setup_autosave(chat)
      			update_buffer_name(chat)
      		end

      		return chat
      	end

      	function M.restore_all_chats()
      		local dir = get_chat_dir()
      		if vim.fn.isdirectory(dir) == 0 then
      			return
      		end

      		local files = vim.fn.glob(dir .. "/*.lua", false, true)
      		local count = 0

      		for _, filepath in ipairs(files) do
      			if M.restore_chat(filepath) then
      				count = count + 1
      			end
      		end

      		if count > 0 then
      			vim.notify(string.format("Restored %d saved chat(s)", count), vim.log.levels.INFO)
      		end
      	end

      	-- ============================================================================
      	-- SETUP
      	-- ============================================================================

      	function M.setup(opts)
      		config = vim.tbl_deep_extend("force", config, opts or {})

      		vim.api.nvim_create_autocmd("FileType", {
      			pattern = "codecompanion",
      			callback = function(args)
      				vim.keymap.set("n", config.toggle_key, function()
      					local chat = require("codecompanion.interactions.chat").buf_get_chat(args.buf)
      					M.toggle_save(chat)
      				end, {
      					buffer = args.buf,
      					desc = "Toggle chat saving",
      					silent = true,
      				})
      			end,
      		})

      		if config.auto_restore then
      			vim.api.nvim_create_autocmd("VimEnter", {
      				once = true,
      				callback = function()
      					vim.defer_fn(function()
      						if find_ai_dir() then
      							M.restore_all_chats()
      						end
      					end, 500)
      				end,
      			})
      		end
      	end

      	-- ============================================================================
      	-- AUTO-INITIALIZE
      	-- ============================================================================

      	-- M.setup()
      end
    '';
  };
}
