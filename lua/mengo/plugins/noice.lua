return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		lsp = {
			hover = {
				-- enabled=false
			},
			progress = { enabled = false }, -- fidget owns LSP progress (lsp.lua)
			signature = { enabled = false }, -- blink.cmp owns signature help (lsp.lua signature.enabled)
			-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
			-- (stylize_markdown is deprecated in 0.12 and core hover no longer calls it)
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				-- ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
			},
		},
		-- -- you can enable a preset for easier configuration
		presets = {
			bottom_search = true, -- use a classic bottom cmdline for search
			command_palette = true, -- position the cmdline and popupmenu together
			-- long_message_to_split = true, -- long messages will be sent to a split
			-- inc_rename = false,         -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = true, -- add a border to hover docs and signature help
		},
	},
	dependencies = {
		-- notifications rendered by snacks.notifier (replaces nvim-notify)
		"MunifTanjim/nui.nvim",
	},
}
