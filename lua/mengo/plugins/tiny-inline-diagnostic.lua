return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "VeryLazy",
	config = function()
		require("tiny-inline-diagnostic").setup({
			preset = "powerline",
			options = {
				add_messages = {
					display_count = true,
					messages = true,
				},
				multilines = {
					always_show = true,
					enabled = true,
				},
			},
		})
		-- Renders diagnostics inline itself; stock virtual_text would double up.
		vim.diagnostic.config({ virtual_text = false })
	end,
}
