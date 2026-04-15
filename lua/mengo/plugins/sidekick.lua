return {
	{
		"folke/sidekick.nvim",
		opts = {
			nes = { enabled = false }, -- no Copilot subscription
			cli = {
				win = {
					layout = "left",
					split = { width = 90 },
				},
				mux = {
					backend = "tmux",
					enabled = true, -- persist CLI sessions across restarts
				},
				picker = "snacks", -- already have snacks.nvim
			},
		},
    -- stylua: ignore
		keys = {
			-- NES keymaps (disabled — no Copilot subscription)
			-- {
			-- 	"<Tab>",
			-- 	function()
			-- 		return require("sidekick.nes").accept() or "<Tab>"
			-- 	end,
			-- 	expr = true,
			-- 	desc = "Goto/Apply Next Edit Suggestion",
			-- },

			-- CLI keymaps
			{ "<c-.>",      function() require("sidekick.cli").focus() end,                                desc = "Sidekick Focus",           mode = { "n", "t", "i", "x" } },
			{ "<leader>aa", function() require("sidekick.cli").toggle() end,                               desc = "Sidekick Toggle CLI" },
			{ "<leader>as", function() require("sidekick.cli").select() end,                               desc = "Select CLI" },
			{ "<leader>ad", function() require("sidekick.cli").close() end,                                desc = "Detach a CLI Session" },
			{ "<leader>at", function() require("sidekick.cli").send({ msg = "{this}" }) end,               desc = "Send This",                mode = { "x", "n" } },
			{ "<leader>af", function() require("sidekick.cli").send({ msg = "{file}" }) end,               desc = "Send File" },
			{ "<leader>av", function() require("sidekick.cli").send({ msg = "{selection}" }) end,          desc = "Send Visual Selection",    mode = { "x" } },
			{ "<leader>ap", function() require("sidekick.cli").prompt() end,                               desc = "Sidekick Select Prompt",   mode = { "n", "x" } },
			{ "<leader>ac", function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end, desc = "Sidekick Toggle Claude" },
			{ "<leader>aD", function() require("sidekick.cli").close({ kill = true }) end,                    desc = "Kill CLI Session" },
		},
	},
}
