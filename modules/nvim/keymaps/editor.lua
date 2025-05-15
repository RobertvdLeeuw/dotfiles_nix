-- Comments
vim.keymap.set({ "n", "v" }, "<C-c>", ":CommentToggle<CR>", { noremap = true, silent = true })

-- Yanking
vim.keymap.set({ "n", "v" }, "<C-y>", [["+y]])

-- Cursor movements
-- vim.keymap.set({ "n", "v", "t" }, "<C-Left>", "b", { noremap = true, silent = true })
-- vim.keymap.set({ "n", "v", "t" }, "<C-Right>", "e", { noremap = true, silent = true })

-- vim.keymap.set("i", "<C-Left>", "<C-o>b", { noremap = true, silent = true })
-- vim.keymap.set("i", "<C-Right>", "<C-o>e<C-o>l", { noremap = true, silent = true })

-- Normal and visual mode - Ctrl+Backspace with improved handling for single character "words"
-- vim.keymap.set({ "n", "v", "t" }, "<C-BS>", function()
-- 	local col = vim.fn.col(".")
-- 	local line = vim.fn.getline(".")
-- 	local char_before = line:sub(col - 1, col - 1)

-- 	if col > 1 and char_before:match("[%s%p]") then
-- 		-- If character before cursor is whitespace or punctuation, just delete it and the character under cursor
-- 		return "hxx"
-- 	else
-- 		return "dbx"
-- 	end
-- end, { noremap = true, silent = true, expr = true })

-- vim.keymap.set({ "n", "v", "t" }, "<C-Del>", "dw", { noremap = true, silent = true })

-- vim.keymap.set("i", "<C-BS>", "<C-w>", { noremap = true, silent = true })
-- vim.keymap.set("i", "<C-Del>", "<C-o>dw", { noremap = true, silent = true })

vim.keymap.set({ "n", "v", "i", "t" }, "<S-Left>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v", "i", "t" }, "<S-Right>", "<Nop>", { noremap = true, silent = true })



-- Venvs
local venv_cache = {}

local function find_project_root(start_path)
	local current_path = start_path or vim.fn.getcwd()

	while current_path ~= "" do
		-- Check for common project root indicators
		if
			vim.fn.isdirectory(current_path .. "/.git") == 1
			or vim.fn.filereadable(current_path .. "/shell.nix") == 1
			or vim.fn.isdirectory(current_path .. "/.venv") == 1
			or vim.fn.isdirectory(current_path .. "/src") == 1
		then
			return current_path
		end

		-- Go up one directory
		local parent_path = vim.fn.fnamemodify(current_path, ":h")
		if parent_path == current_path then
			break
		end
		current_path = parent_path
	end

	return nil
end

local function find_nix_shell(start_path)
	-- Check cache first
	local project_root = find_project_root(start_path)
	if not project_root then
		return nil
	end
  
  if not vim.fn.filereadable(project_root .. "/shell.nix") == 1 then
    return nil
  end

  return project_root
end

local function get_activate_path()
	local shell = find_nix_shell()
	if not shell then
		return ""
	end

	return 'cd "' .. shell_loc .. '" && nix-shell && cd -; clear;'
end

local function setup_terminal(term)
  term:send(get_activate_path())
end

require("toggleterm").setup({
  shell = "/nix/store/kp4g2a8w1mh7ybvlkis23d029zq0bm8x-system-path/bin/zsh",
	on_create = setup_terminal,
})

-- Terminal functions for running scripts
local Terminal = require("toggleterm.terminal").Terminal

-- Universal terminal handler function
local function universal_terminal_handler()
	-- First check if the run output terminal is open and close it if it is
	if Current_run_terminal and Current_run_terminal:is_open() then
		Current_run_terminal:close()
		return true
	end

	-- If we're already in a terminal buffer, close it
	local current_buf = vim.api.nvim_get_current_buf()
	local buf_type = vim.api.nvim_buf_get_option(current_buf, "buftype")
	if buf_type == "terminal" then
		vim.cmd("close")
		return true
	end

	-- If no terminal is open or active, let the default <C-Space> behavior handle it
	-- (which is to open the regular terminal via toggleterm's open_mapping)
	return false
end

-- Function to run the current file based on filetype
local function run_current_file()
	local file = vim.fn.expand("%:p")
	local filetype = vim.bo.filetype

	local commands = {
		python = 'python3 "' .. file .. '"',
		lua = 'lua "' .. file .. '"',
		javascript = 'node "' .. file .. '"',
		typescript = 'ts-node "' .. file .. '"',
		rust = "cargo run",
		go = 'go run "' .. file .. '"',
		sh = 'bash "' .. file .. '"',
		cpp = 'g++ "' .. file .. '" -o ' .. vim.fn.expand("%:p:r") .. " && " .. vim.fn.expand("%:p:r"),
		c = 'gcc "' .. file .. '" -o ' .. vim.fn.expand("%:p:r") .. " && " .. vim.fn.expand("%:p:r"),
		java = 'javac "' .. file .. '" && java ' .. vim.fn.expand("%:t:r"),
	}

	local cmd = commands[filetype]
	if cmd then
		-- Close existing run terminal if it's open
		if Current_run_terminal and Current_run_terminal:is_open() then
			Current_run_terminal:close()
		end

		local run_current = Terminal:new({
			cmd = get_activate_path() .. cmd,
			direction = "horizontal",
			close_on_exit = false,
			on_open = function(term)
				Current_run_terminal = term
			end,
		})
		run_current:toggle()
	else
		print("Filetype '" .. filetype .. "' not supported for running.")
	end
end

local function run_project_main()
	local main_files = {
		python = { "main.py", "src/main.py", "run.py" },
		javascript = { "main.js", "index.js", "app.js" },
		typescript = { "main.ts", "index.ts", "app.ts" },
		rust = { "src/main.rs" },
		go = { "main.go" },
		java = { "Main.java", "App.java" },
	}

	local filetype = vim.bo.filetype
	local possible_mains = main_files[filetype]

	if possible_mains then
		-- Get project root directory
		local project_root = vim.fn.getcwd()
		local main_file = nil

		-- Find the first existing main file
		for _, file in ipairs(possible_mains) do
			local full_path = project_root .. "/" .. file
			if vim.fn.filereadable(full_path) == 1 then
				main_file = full_path
				break
			end
		end

		if main_file then
			local commands = {
				python = "python3 " .. main_file,
				javascript = "node " .. main_file,
				typescript = "ts-node " .. main_file,
				rust = "cargo run",
				go = "go run " .. main_file,
				java = "javac " .. main_file .. " && java " .. vim.fn.fnamemodify(main_file, ":t:r"),
			}

			local cmd = commands[filetype]
			if cmd then
				-- Close existing run terminal if it's open
				if Current_run_terminal and Current_run_terminal:is_open() then
					Current_run_terminal:close()
				end

				local run_main = Terminal:new({
					cmd = get_activate_path() .. cmd,
					direction = "horizontal",
					close_on_exit = false,
					on_open = function(term)
						-- Set as current run terminal when opened
						Current_run_terminal = term
					end,
				})
				run_main:toggle()
			end
		else
			print("No main file found for " .. filetype .. " project.")
		end
	else
		print("Filetype '" .. filetype .. "' not supported for project execution.")
	end
end

-- Setup function to be called after toggleterm is initialized
local function setup_universal_terminal_control()
	-- Override the default C-Space behavior with our universal handler
	vim.api.nvim_set_keymap(
		"n",
		"<C-Space>",
		'<cmd>lua if not universal_terminal_handler() then vim.cmd("ToggleTerm") end<CR>',
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"t",
		"<C-Space>",
		"<C-\\><C-n><cmd>lua universal_terminal_handler()<CR>",
		{ noremap = true, silent = true }
	)

	-- Also make Esc work from normal mode to close the output terminal
	vim.api.nvim_set_keymap(
		"n",
		"<Esc>",
		"<cmd>lua if current_run_terminal and current_run_terminal:is_open() then current_run_terminal:close() end<CR>",
		{ noremap = true, silent = true }
	)
end

-- Run keymaps
vim.api.nvim_set_keymap("n", "<F5>", ":w<CR><cmd>lua run_current_file()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F6>", ":w<CR><cmd>lua run_project_main()<CR>", { noremap = true, silent = true })

-- Make the functions globally available
_G.run_current_file = run_current_file
_G.run_project_main = run_project_main
_G.universal_terminal_handler = universal_terminal_handler
_G.setup_universal_terminal_control = setup_universal_terminal_control

-- Set up an autocommand to initialize our terminal control after ToggleTerm is loaded
vim.api.nvim_create_autocmd({ "VimEnter" }, {
	callback = function()
		-- Give ToggleTerm time to set up first
		vim.defer_fn(function()
			setup_universal_terminal_control()
		end, 100)
	end,
})

