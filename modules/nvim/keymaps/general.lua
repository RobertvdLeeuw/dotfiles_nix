-- Quit
vim.keymap.set({ "n", "t" }, "<C-q>", function()
	-- Save all buffers first
	vim.cmd("wa")

	-- Call the session save function from your plugin
	-- Replace this with the correct command for your specific plugin
	-- if vim.fn.exists(":SessionSave") == 2 then
	-- 	vim.cmd("SessionSave")
	-- elseif pcall(require, "auto-session") then
	-- 	require("auto-session").SaveSession()
	-- elseif pcall(require, "persisted") then
	-- 	require("persisted").save()
	-- elseif pcall(require, "session_manager") then
	-- 	require("session_manager").save_current_session()
	-- end

	-- Then quit all
	vim.cmd("qa")
end, { noremap = true, silent = true })

-- Autosession stuff (move to somewhere in after/)
-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	callback = function()
-- 		-- Only try to restore if no files were specified on the command line
-- 		if vim.fn.argc() == 0 and not vim.fn.exists("$NVIM_LISTEN_ADDRESS") then
-- 			if vim.fn.exists(":SessionRestore") == 2 then
-- 				vim.cmd("SessionRestore")
-- 			elseif pcall(require, "auto-session") then
-- 				require("auto-session").RestoreSession()
-- 			elseif pcall(require, "persisted") then
-- 				require("persisted").load()
-- 			elseif pcall(require, "session_manager") then
-- 				require("session_manager").load_current_session()
-- 			end
-- 		end
-- 	end,
-- })

-- vim.api.nvim_create_autocmd("VimLeavePre", {
-- 	callback = function()
-- 		if vim.fn.exists(":SessionPurgeOrphaned") == 2 then
-- 			vim.cmd("SessionPurgeOrphaned")
-- 		end
-- 	end,
-- })
