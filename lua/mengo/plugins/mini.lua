return {
	{
		"echasnovski/mini.nvim",
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				init = function()
					-- Prevent the plugin from loading its vim file (it requires the old nvim-treesitter.configs API).
					-- We only need it for the textobjects.scm query files that mini.ai uses.
					require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
				end,
			},
		},
		version = false,
		config = function()
			require("mini.surround").setup({
				highlight_duration = 500,
				mappings = {
					add = "ys",
					delete = "ds",
					find = "",
					find_left = "",
					highlight = "",
					replace = "cs",
					update_n_lines = "",

					-- Add this only if you don't want to use extended mappings
					suffix_last = "",
					suffix_next = "",
				},
				search_method = "cover_or_next",
			})
			local spec_treesitter = require("mini.ai").gen_spec.treesitter
			require("mini.ai").setup({
				n_lines = 500,
				custom_textobjects = {
					a = spec_treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
					c = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),
					f = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
					F = spec_treesitter({ a = "@call.outer", i = "@call.inner" }),
					i = spec_treesitter({
						a = { "@conditional.outer", "@loop.outer" },
						i = { "@conditional.inner", "@loop.inner" },
					}),
					l = spec_treesitter({
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}),
				},
			})
			require("mini.pairs").setup({})
			require("mini.bracketed").setup({})
			-- require("mini.operators").setup()
			-- require("mini.splitjoin").setup({
			--   mappings = {
			--     toggle = '<leader>m',
			--     split = '<leader>M',
			--     join = '',
			--   },
			-- })
		end,
	},
}
