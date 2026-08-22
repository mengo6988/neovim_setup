return {
	"hedyhli/outline.nvim",
	cmd = "Outline",
	-- dmmulroy binds this to <leader>so, but that's already ":source %" here.
	keys = {
		{ "<leader>oo", "<cmd>Outline<cr>", desc = "Toggle symbol outline" },
	},
	opts = {},
}
