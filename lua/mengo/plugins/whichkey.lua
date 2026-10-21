return {

	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		-- Pure prefixes only: <leader>v/s/c/x/q/a/b/f are real maps, a group label would hide their desc
		spec = {
			{ "<leader>g", group = "git" },
			{ "<leader>gh", group = "hunk" },
			{ "<leader>p", group = "pick / project" },
			{ "<leader>n", group = "noice / no-neck-pain" },
			{ "<leader>l", group = "lazygit / lazydocker / lazysql" },
			{ "<leader>t", group = "trouble / terminal" },
			{ "<leader>d", group = "debug / db / duck" },
			{ "<leader>y", group = "yank with path", mode = "n" },
			{ "<leader>i", group = "toggles" },
			{ "<leader>o", group = "outline / nvumi" },
		},
	},
}
