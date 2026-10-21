return {
	-- maintained fork of sindrets/diffview.nvim (dormant since 2024); same lua/diffview module and commands
	"dlyongemallo/diffview-plus.nvim",
	name = "diffview.nvim", -- keeps the lock key and catppuccin's auto-detected diffview integration
	version = "*",
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
	-- Everyday diffs go through `:Gitsigns diff` (<leader>gD in plugins/init.lua).
	-- Diffview stays for file history and the merge tool, which gitsigns lacks.
	keys = {
		{ "<leader>gH", "<cmd>DiffviewFileHistory %<CR>", desc = "[G]it file [H]istory" },
		{ "<leader>gq", "<cmd>DiffviewClose<CR>", desc = "[G]it diffview [Q]uit" },
	},
	opts = {
		enhanced_diff_hl = true,
		view = {
			merge_tool = {
				layout = "diff3_mixed",
				disable_diagnostics = true,
			},
		},
	},
}
