return {
	-- Winbar breadcrumbs. Replaces barbecue.nvim (archived 2024-08-20) + nvim-navic;
	-- dropbar has no dependencies and sources symbols from LSP, treesitter, markdown,
	-- path, and terminal on its own.
	"Bekaboo/dropbar.nvim",
	event = { "BufReadPost", "BufNewFile" },
	keys = {
		{
			"<leader>;",
			function()
				require("dropbar.api").pick()
			end,
			desc = "Pick symbol in winbar",
		},
	},
	config = function()
		-- Capture the stock enable before setup() overwrites configs.opts, otherwise
		-- calling it from inside our own enable would recurse.
		local default_enable = require("dropbar.configs").opts.bar.enable

		require("dropbar").setup({
			bar = {
				-- dropbar's default already needs a treesitter parser or documentSymbol
				-- support, which rules out oil and dashboard buffers. These would
				-- otherwise slip through and add noise.
				enable = function(buf, win, src)
					local ft = vim.bo[buf].ft
					if ft == "gitcommit" or ft == "toggleterm" then
						return false
					end
					return default_enable(buf, win, src)
				end,
			},
		})
	end,
}
