vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.expandtab = false
vim.opt.wrap = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.showmode = true
vim.opt.showmatch = true
vim.opt.hlsearch = true
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest"
vim.opt.wildignore = "*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx"

vim.opt.statusline = " %F %M %Y %R%= row: %l col: %c percent: %p%%"
vim.opt.laststatus = 2

vim.opt.list = true
vim.opt.listchars = { tab = '>-' }

local autocmd = vim.api.nvim_create_autocmd
autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local line = mark[1]
		local col = mark[2]
		if line > 0 and line <= vim.api.nvim_buf_line_count(0) then
			local line_text = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]
			local line_length = #line_text
			local safe_col = math.min(col, line_length)
			vim.api.nvim_win_set_cursor(0, {line, safe_col})
		end
	end,
})

local ft_group = vim.api.nvim_create_augroup("DisableNixFtplugin", { clear = true })
autocmd("FileType", {
	pattern = { "nix", "rust" },
	group = ft_group,
	callback = function()
		vim.b.did_ftplugin = 1
	end,
})

