return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	init = function()
		-- Your DBUI configuration
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_execute_on_save = 0

		-- Run the statement under the cursor (paragraph if multi-line).
		-- dadbod-ui's <leader>S runs the whole buffer in normal mode and the
		-- selection in visual mode, so select the surrounding paragraph first.
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "sql", "mysql", "plsql" },
			callback = function(ev)
				vim.keymap.set("n", "<leader>se", "vip<leader>S", {
					buffer = ev.buf,
					remap = true,
					desc = "DB: run statement under cursor",
				})
			end,
		})
	end,
}
