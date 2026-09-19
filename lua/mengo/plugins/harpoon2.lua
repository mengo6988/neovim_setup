return {

	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },

	keys = {
		{
			"<leader>a",
			function()
				require("harpoon"):list():add()
			end,
			desc = "Harpoon: add file",
		},
		{
			"<C-e>",
			function()
				local harpoon = require("harpoon")
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end,
			desc = "Harpoon: toggle quick menu",
		},
		{
			"<leader>1",
			function()
				require("harpoon"):list():select(1)
			end,
			desc = "Harpoon: go to file 1",
		},
		{
			"<leader>2",
			function()
				require("harpoon"):list():select(2)
			end,
			desc = "Harpoon: go to file 2",
		},
		{
			"<leader>3",
			function()
				require("harpoon"):list():select(3)
			end,
			desc = "Harpoon: go to file 3",
		},
		{
			"<leader>4",
			function()
				require("harpoon"):list():select(4)
			end,
			desc = "Harpoon: go to file 4",
		},
		-- Toggle previous & next buffers stored within Harpoon list
		{
			"<M-h>",
			function()
				require("harpoon"):list():prev()
			end,
			desc = "Harpoon: previous buffer",
		},
		{
			"<M-l>",
			function()
				require("harpoon"):list():next()
			end,
			desc = "Harpoon: next buffer",
		},
	},

	config = function()
		-- REQUIRED
		require("harpoon"):setup()
		-- REQUIRED
	end,
}
