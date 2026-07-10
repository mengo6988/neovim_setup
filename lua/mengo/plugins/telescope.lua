return {
	{
		"nvim-telescope/telescope.nvim",

		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			{ "benfowler/telescope-luasnip.nvim" },
		},

		config = function()
			local cursor_theme = {
				sorting_strategy = "ascending",
				results_title = false,
				layout_strategy = "cursor",
				layout_config = {
					width = 200,
					height = 21,
				},
				borderchars = {
					prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
					results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
					preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
				},
			}
			-- LSP pickers should never hide results, even in ignored dirs
			local cursor_theme_no_ignore = vim.tbl_extend("force", cursor_theme, { file_ignore_patterns = {} })
			require("telescope").setup({
				defaults = {
					sorting_strategy = "ascending",
					-- --hidden so dotfiles are searchable; .git/ stays out via file_ignore_patterns
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
					},
					file_ignore_patterns = {
						"node_modules/",
						"public/",
						".git/",
						"dist/",
						"build/",
						".next/",
						"%.lock",
					},

					layout_strategy = "bottom_pane",
					layout_config = {
						height = 0.5,
					},

					border = true,
					borderchars = {
						prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
						results = { " " },
						preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					},
				},
				pickers = {
					find_files = { hidden = true },
					grep_string = cursor_theme,
					lsp_definitions = cursor_theme_no_ignore,
					lsp_references = cursor_theme_no_ignore,
					lsp_implementations = cursor_theme_no_ignore,
					lsp_type_definitions = cursor_theme_no_ignore,
					lsp_dynamic_workspace_symbols = cursor_theme,
					lsp_document_symbols = cursor_theme,
				},
				extensions = {
					fzf = {},
					["ui-select"] = require("telescope.themes").get_dropdown({}),
				},
			})
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("ui-select")
			require("telescope").load_extension("luasnip")
			-- pcall(require('telescope').load_extension, 'fzf')
			-- pcall(require('telescope').load_extension, 'ui-select')

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ph", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
			vim.keymap.set("n", "<leader>pb", builtin.builtin, {})
			vim.keymap.set("n", "<leader>pg", builtin.git_files, {})
			vim.keymap.set("n", "<leader>pt", builtin.treesitter, {})
			-- vim.keymap.set('n', '<leader>psw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
			vim.keymap.set("n", "<leader>ps", builtin.live_grep, { desc = "[S]earch word" })
			vim.keymap.set("n", "<leader>psw", function()
				local word = vim.fn.expand("<cWORD>")
				builtin.grep_string({ search = word })
			end)
			vim.keymap.set("n", "<leader>pss", function()
				builtin.grep_string({ search = vim.fn.input("Grep > ") })
			end)

			-- deferred: indexing extensions.flutter at setup time force-loads
			-- flutter-tools.nvim at startup, defeating its ft = "dart" lazy trigger
			vim.keymap.set("n", "<leader>pr", function()
				require("telescope").extensions.flutter.commands()
			end, { desc = "Open command Flutter" })

			-- Shortcut for searching your Neovim configuration files
			vim.keymap.set("n", "<leader>psn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })

			vim.keymap.set("n", "<leader>psp", function()
				builtin.find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
			end, { desc = "[S]earch [P]ackages" })

			vim.keymap.set("n", "<leader>psc", function()
				require("telescope").extensions.luasnip.luasnip()
			end, { desc = "[S]earch [S]nippets" })

			vim.keymap.set("n", "<leader>p.", builtin.resume, { desc = "Resume last picker" })
			vim.keymap.set("n", "<leader>po", builtin.oldfiles, { desc = "Recent files" })
			vim.keymap.set("n", "<leader>p/", builtin.current_buffer_fuzzy_find, { desc = "Fuzzy find in buffer" })
			vim.keymap.set("n", "<leader>pk", builtin.keymaps, { desc = "Search keymaps" })
			vim.keymap.set("v", "<leader>ps", function()
				local text = table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos(".")), "\n")
				builtin.grep_string({ search = text })
			end, { desc = "Grep selection" })

			require("mengo.telescope.multigrep").setup()
		end,
	},
	{
		-- theme + load_extension handled in the main telescope setup above;
		-- a second telescope.setup() here would clobber the first
		"nvim-telescope/telescope-ui-select.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
	},
	{
		"coffebar/neovim-project",
		opts = {
			projects = { -- define project roots
				"~/Downloads/projects/*",
				"~/Downloads/projects/elvtd/*",
				"~/.config/*",
				"~/Documents/obsidian/*",
			},
		},
		init = function()
			-- enable saving the state of plugins in the session
			vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
		end,
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
			{ "Shatur/neovim-session-manager" },
		},
		lazy = false,
		priority = 100,
	},
	-- {
	--   "nvim-telescope/telescope-media-files.nvim",
	--   config = function()
	--     require('telescope').load_extension('media_files')
	--   end
	-- }
}
