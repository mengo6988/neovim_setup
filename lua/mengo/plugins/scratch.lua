return {
	"LintaoAmons/scratch.nvim",
	event = "VeryLazy",
	dependencies = {
		{ "ibhagwan/fzf-lua" }, --optional: if you want to use fzf-lua to pick scratch file. Recommanded, since it will order the files by modification datetime desc. (require rg)
		{ "nvim-telescope/telescope.nvim" }, -- optional: if you want to pick scratch file by telescope
		-- {"stevearc/dressing.nvim"} -- optional: removed, noice + telescope-ui-select covers this
	},
	config = function()
		require("scratch").setup({
			scratch_file_dir = vim.fn.stdpath("cache") .. "/scratch.nvim", -- where your scratch files will be put
			window_cmd = "rightbelow vsplit", -- 'vsplit' | 'split' | 'edit' | 'tabedit' | 'rightbelow vsplit'
			-- fzf-lua is recommanded, since it will order the files by modification datetime desc. (require rg)
			file_picker = "fzflua", -- "fzflua" | "telescope" | nil
			filetypes = { "lua", "js", "sh", "ts", "py" }, -- you can simply put filetype here
			filetype_details = { -- or, you can have more control here
				json = {}, -- empty table is fine
				["project-name.md"] = {
					subdir = "project-name", -- group scratch files under specific sub folder
				},
				["yaml"] = {},
				go = {
					subdir = true, -- each scratch file gets its own directory (was requireDir, deprecated)
					filename = "main", -- the filename of the scratch file in the new directory
					content = { "package main", "", "func main() {", "  ", "}" },
					cursor = {
						location = { 4, 2 },
						insert_mode = true,
					},
				},
			},
			-- localKeys removed: it bound <C-r> to :RunShellCurrentLine, a command
			-- that doesn't exist anywhere (E492 on press)
			hooks = {
				{
					callback = function()
						-- vim.api.nvim_buf_set_lines(0, 0, -1, false, { "hello", "world" })
					end,
				},
			},
		})
	end,
}
