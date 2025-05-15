vim.keymap.set({ "n", "v" }, "<C-t>", ":tabnew<CR>")
vim.keymap.set({ "n", "v" }, "<C-A-h>", ":tabprevious<CR>")
vim.keymap.set({ "n", "v" }, "<C-A-l>", ":tabnext<CR>")

vim.keymap.set("i", "<C-t>", "<C-o>:tabnew<CR><Esc>")
vim.keymap.set("i", "<C-A-Left>", "<C-o>:tabprevious<CR>")
vim.keymap.set("i", "<C-A-Right>", "<C-o>:tabnext<CR>")
vim.keymap.set("i", "<C-A-h>", "<C-o>:tabprevious<CR>")
vim.keymap.set("i", "<C-A-l>", "<C-o>:tabnext<CR>")

vim.keymap.set("t", "<C-t>", "<cmd>:tabnew<CR><Esc>")
vim.keymap.set("t", "<C-A-Left>", "<cmd>:tabprevious<CR>")
vim.keymap.set("t", "<C-A-Right>", "<cmd>:tabnext<CR>")
vim.keymap.set("t", "<C-A-h>", "<cmd>:tabprevious<CR>")
vim.keymap.set("t", "<C-A-l>", "<cmd>:tabnext<CR>")

-- Goto tab
vim.keymap.set({ "n", "v" }, "<C-1>", "1gt")
vim.keymap.set({ "n", "v" }, "<C-2>", "2gt")
vim.keymap.set({ "n", "v" }, "<C-3>", "3gt")
vim.keymap.set({ "n", "v" }, "<C-4>", "4gt")
vim.keymap.set({ "n", "v" }, "<C-5>", "5gt")
vim.keymap.set({ "n", "v" }, "<C-6>", "6gt")
vim.keymap.set({ "n", "v" }, "<C-7>", "7gt")
vim.keymap.set({ "n", "v" }, "<C-8>", "8gt")
vim.keymap.set({ "n", "v" }, "<C-9>", "9gt")
vim.keymap.set({ "n", "v" }, "<C-0>", "0gt")

vim.keymap.set("i", "<C-1>", "<C-o>1gt")
vim.keymap.set("i", "<C-2>", "<C-o>2gt")
vim.keymap.set("i", "<C-3>", "<C-o>3gt")
vim.keymap.set("i", "<C-4>", "<C-o>4gt")
vim.keymap.set("i", "<C-5>", "<C-o>5gt")
vim.keymap.set("i", "<C-6>", "<C-o>6gt")
vim.keymap.set("i", "<C-7>", "<C-o>7gt")
vim.keymap.set("i", "<C-8>", "<C-o>8gt")
vim.keymap.set("i", "<C-9>", "<C-o>9gt")
vim.keymap.set("i", "<C-0>", "<C-o>0gt")


vim.keymap.set("t", "<C-1>", "<cmd>:1 tabn<CR>")
vim.keymap.set("t", "<C-2>", "<cmd>:2 tabn<CR>")
vim.keymap.set("t", "<C-3>", "<cmd>:3 tabn<CR>")
vim.keymap.set("t", "<C-4>", "<cmd>:4 tabn<CR>")
vim.keymap.set("t", "<C-5>", "<cmd>:5 tabn<CR>")
vim.keymap.set("t", "<C-6>", "<cmd>:6 tabn<CR>")
vim.keymap.set("t", "<C-7>", "<cmd>:7 tabn<CR>")
vim.keymap.set("t", "<C-8>", "<cmd>:8 tabn<CR>")
vim.keymap.set("t", "<C-9>", "<cmd>:9 tabn<CR>")
vim.keymap.set("t", "<C-0>", "<cmd>:0 tabn<CR>")

--

vim.g.last_closed_file = ""

local function store_current_file()
	-- Only store if it's a real file (has a name and isn't a special buffer)
	if vim.fn.expand("%") ~= "" and vim.bo.filetype ~= "netrw" then
		vim.g.last_closed_file = vim.fn.expand("%:p")
	end
end

vim.api.nvim_create_autocmd({ "BufLeave", "TabLeave" }, {
	callback = function()
		store_current_file()
	end,
	group = vim.api.nvim_create_augroup("RememberClosedFile", { clear = true }),
	desc = "Remember the last closed file",
})

vim.keymap.set("n", "<C-w>", function()
	-- store_current_file()

	-- Save if applicable
	if vim.fn.expand("%") ~= "" and vim.bo.filetype ~= "netrw" then
		vim.cmd("w")
	end

	vim.cmd("tabclose")
end)

vim.keymap.set({ "n", "i", "t", "v" }, "<C-S-t>", function()
	if vim.g.last_closed_file ~= "" then
		vim.cmd("tabedit " .. vim.g.last_closed_file)
	end
end)
