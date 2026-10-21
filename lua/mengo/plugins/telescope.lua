-- Key callback for a telescope builtin picker; get_opts runs at keypress (cWORD, input, selection)
local function pick(name, get_opts)
	return function()
		require("telescope.builtin")[name](get_opts and get_opts() or nil)
	end
end

return {
	{
		"nvim-telescope/telescope.nvim",
		-- Still loaded at startup while neovim-project (lazy = false) depends on it;
		-- these triggers make it lazy once that dependency goes.
		cmd = "Telescope",
		keys = {
			{ "<leader>ph", pick("help_tags"), desc = "[S]earch [H]elp" },
			{ "<leader>pf", pick("find_files"), desc = "[S]earch [F]iles" },
			{ "<leader>pb", pick("builtin"), desc = "[S]earch [B]uiltin pickers" },
			{ "<leader>pg", pick("git_files"), desc = "[S]earch [G]it files" },
			{ "<leader>pt", pick("treesitter"), desc = "[S]earch [T]reesitter symbols" },
			{ "<leader>ps", pick("live_grep"), desc = "[S]earch word" },
			{
				"<leader>psw",
				pick("grep_string", function()
					return { search = vim.fn.expand("<cWORD>") }
				end),
				desc = "[S]earch current [W]ord",
			},
			{
				"<leader>pss",
				pick("grep_string", function()
					return { search = vim.fn.input("Grep > ") }
				end),
				desc = "[S]earch for input [S]tring",
			},
			{
				"<leader>ps",
				pick("grep_string", function()
					return { search = table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos(".")), "\n") }
				end),
				mode = "v",
				desc = "Grep selection",
			},
			-- deferred: indexing extensions.flutter at setup time force-loads
			-- flutter-tools.nvim at startup, defeating its ft = "dart" lazy trigger
			{
				"<leader>pr",
				function()
					require("telescope").extensions.flutter.commands()
				end,
				desc = "Open command Flutter",
			},
			{
				"<leader>psn",
				pick("find_files", function()
					return { cwd = vim.fn.stdpath("config") }
				end),
				desc = "[S]earch [N]eovim files",
			},
			{
				"<leader>psp",
				pick("find_files", function()
					return { cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") }
				end),
				desc = "[S]earch [P]ackages",
			},
			{
				"<leader>psc",
				function()
					require("telescope").extensions.luasnip.luasnip()
				end,
				desc = "[S]earch [S]nippets",
			},
			{
				"<leader>psg",
				function()
					require("mengo.telescope.multigrep").live_multigrep()
				end,
				desc = "[S]earch by [G]rep (multi)",
			},
			{ "<leader>p.", pick("resume"), desc = "Resume last picker" },
			{ "<leader>po", pick("oldfiles"), desc = "Recent files" },
			{ "<leader>p/", pick("current_buffer_fuzzy_find"), desc = "Fuzzy find in buffer" },
			{ "<leader>pk", pick("keymaps"), desc = "Search keymaps" },
		},

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
			-- keymaps live in `keys` above so they exist before telescope loads
		end,
	},
	{
		-- theme + load_extension handled in the main telescope setup above;
		-- a second telescope.setup() here would clobber the first
		"nvim-telescope/telescope-ui-select.nvim",
		lazy = true,
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
		-- session restore must run before buffers load
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
