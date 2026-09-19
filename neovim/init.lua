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

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = {
					"vim",
				},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

vim.lsp.enable("nil_ls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("clangd")
vim.lsp.enable("html")
vim.lsp.enable("cssls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("csharp_ls")

require("blink.cmp").setup({
	keymap = {
		preset = "default",
	},
	completion = {
		documentation = {
			auto_show = true,
		},
	},
	sources = {
		default = {
			"lsp",
			"path",
			"buffer",
		},
	},
})

