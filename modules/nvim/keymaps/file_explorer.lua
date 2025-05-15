-- NNN
-- Open
vim.keymap.set("n", "<C-e>", function()
	if vim.fn.expand("%") ~= "" then
		vim.cmd("w")
	end
	vim.cmd(":NnnPicker %:p:h")
end, { noremap = true, silent = true })

-- Telescope (double escape in case in nnn)
vim.keymap.set("n", "<C-f>", ":Telescope find_files<CR>")
vim.keymap.set("n", "<S-f>", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<S-t>", ":TodoTelescope<CR>")
vim.keymap.set("n", "<C-g>", ":Telescope git_files<CR>") -- TODO: Handle when not in git repo

-- Escape
-- Global table to track which tabs have opened files
if not _G.netrw_tab_history then
	_G.netrw_tab_history = {}
end
-- TODO


-- NetRW
-- Open
-- vim.keymap.set("n", "<C-e>", function()
-- 	-- Check if we're in a real file (has a name)
-- 	if vim.fn.expand("%") ~= "" then
-- 		vim.cmd("w")
-- 	end
-- 	vim.cmd("Ex")
-- end, { noremap = true, silent = true })

-- -- Auto command to set up the Escape key in netrw
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "netrw",
-- 	callback = function(ev)
-- 		vim.keymap.set("n", "<Esc>", function()
-- 			local current_tab = vim.api.nvim_get_current_tabpage()
-- 			local tab_id = tostring(current_tab)

-- 			if _G.netrw_tab_history[tab_id] then
-- 				local success = pcall(vim.cmd, "Rexplore")

-- 				if not success then
-- 					local alt_buf = vim.fn.bufnr("#")
-- 					if alt_buf ~= -1 and vim.bo[alt_buf].filetype ~= "netrw" then
-- 						vim.cmd("buffer " .. alt_buf)
-- 					end
-- 				end
-- 			else
-- 				-- No files have been opened in this tab, so close it
-- 				vim.cmd("tabclose")
-- 			end
-- 		end, { buffer = ev.buf, noremap = true, silent = true })
-- 	end,
-- })

-- -- Auto command to track when a non-netrw buffer is entered (i.e., a file is opened)
-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	callback = function()
-- 		local buf = vim.api.nvim_get_current_buf()

-- 		-- Only track non-netrw buffers
-- 		if vim.bo[buf].filetype ~= "netrw" and vim.bo[buf].filetype ~= "" then
-- 			local current_tab = vim.api.nvim_get_current_tabpage()
-- 			local tab_id = tostring(current_tab)

-- 			-- Mark this tab as having opened a file
-- 			_G.netrw_tab_history[tab_id] = true
-- 		end
-- 	end,
-- })
