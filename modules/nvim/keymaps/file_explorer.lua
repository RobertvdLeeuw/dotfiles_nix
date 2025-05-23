-- Ranger
-- Open
vim.keymap.set("n", "<C-e>", function()
	if vim.fn.expand("%") ~= "" then
		vim.cmd("w")
	end
	vim.cmd(":Ranger")
end, { noremap = true, silent = true })

-- Telescope (double escape in case in nnn)
vim.keymap.set("n", "<C-f>", ":Telescope find_files<CR>")
vim.keymap.set("n", "<S-f>", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<S-t>", ":TodoTelescope<CR>")
vim.keymap.set("n", "<C-g>", ":Telescope git_files<CR>") -- TODO: Handle when not in git repo

-- Escape
-- Global table to track which tabs have opened files
-- if not _G.netrw_tab_history then
-- 	_G.netrw_tab_history = {}
-- end
