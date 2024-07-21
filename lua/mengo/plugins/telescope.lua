return {
	{

		'nvim-telescope/telescope.nvim',

		dependencies = {
			'nvim-lua/plenary.nvim'
		},

		config = function()
			require('telescope').setup({})
			pcall(require('telescope').load_extension, 'fzf')
			pcall(require('telescope').load_extension, 'ui-select')

			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<leader>ph', builtin.help_tags, { desc = '[S]earch [H]elp' })
			vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
			vim.keymap.set('n', '<leader>pg', builtin.git_files, {})
			vim.keymap.set('n', '<leader>psw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
			vim.keymap.set('n', '<leader>pws', function()
				local word = vim.fn.expand("cWORD")
				builtin.grep_string({ search = word })
			end)
			vim.keymap.set('n', '<leader>ps', function()
				builtin.grep_string({ search = vim.fn.input("Grep > ") })
			end)
			vim.keymap.set('n', '<leader>pr', require('telescope').extensions.flutter.commands,
				{ desc = 'Open command Flutter' })

			vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})
			-- Shortcut for searching your Neovim configuration files
			vim.keymap.set('n', '<leader>psn', function()
				builtin.find_files { cwd = vim.fn.stdpath 'config' }
			end, { desc = '[S]earch [N]eovim files' })
		end
	},
	{
		'nvim-telescope/telescope-ui-select.nvim',
		dependencies = {
			"nvim-telescope/telescope.nvim"
		},
		config = function()
			-- This is your opts table
			require("telescope").setup {
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown {
							-- even more opts
						}

						-- pseudo code / specification for writing custom displays, like the one
						-- for "codeactions"
						-- specific_opts = {
						--   [kind] = {
						--     make_indexed = function(items) -> indexed_items, width,
						--     make_displayer = function(widths) -> displayer
						--     make_display = function(displayer) -> function(e)
						--     make_ordinal = function(e) -> string
						--   },
						--   -- for example to disable the custom builtin "codeactions" display
						--      do the following
						--   codeactions = false,
						-- }
					}
				}
			}
			-- To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("ui-select")
		end
	},
	{
		"coffebar/neovim-project",
		opts = {
			projects = { -- define project roots
				"~/Downloads/projects/*",
				"~/Downloads/projects/elvtd/*",
				"~/.config/*",
			},
		},
		init = function()
			-- enable saving the state of plugins in the session
			vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
		end,
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim", tag = "0.1.4" },
			{ "Shatur/neovim-session-manager" },
		},
		lazy = false,
		priority = 100,
	},
}
