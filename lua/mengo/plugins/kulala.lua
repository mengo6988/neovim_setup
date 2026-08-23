return {
	-- REST/GraphQL/gRPC client. Replaces curl.nvim, whose keymaps were already
	-- commented out over a <leader>c / <leader>f prefix collision. Reads the
	-- JetBrains .http spec, so request files stay portable outside nvim.
	"mistweaverco/kulala.nvim",
	ft = { "http", "rest" },
	keys = {
		{ "<leader>R", "", desc = "+REST (kulala)" },
	},
	opts = {
		-- <leader>Rs send, <leader>Ra send all, <leader>Rb scratchpad.
		-- <leader>R is otherwise unused, so no timeoutlen collision.
		global_keymaps = true,
		global_keymaps_prefix = "<leader>R",
	},
}
