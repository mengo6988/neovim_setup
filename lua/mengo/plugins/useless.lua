return {
	{
		'eandrju/cellular-automaton.nvim',
		cmd = "CellularAutomaton",
	},
	{
		'tamton-aquib/duck.nvim',
		keys = {
			{ '<leader>dd', function() require("duck").hatch() end, desc = "Hatch duck" },
			{ '<leader>dk', function() require("duck").cook() end, desc = "Cook duck" },
			{ '<leader>da', function() require("duck").cook_all() end, desc = "Cook all ducks" },
		},
	},
}
