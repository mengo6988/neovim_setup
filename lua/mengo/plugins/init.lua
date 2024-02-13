return {
	{
		'nvim-lua/plenary.nvim',
		name = 'plenary'
	},
	{
		'numToStr/Comment.nvim',
		lazy = false,
		opts = {

		},
	},
	-- git
	'tpope/vim-fugitive',
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		opts = {} -- this is equalent to setup({}) function
	},
	'github/copilot.vim',
	'eandrju/cellular-automaton.nvim',
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require('gitsigns').setup()
		end
	},
	{
		'stevearc/conform.nvim',
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					python = { "black", "isort" },
					lua = { "stylua" },
					javascript = { "prettier" },
					rust = { "rustfmt" },
					cpp = { "clang-d" },
					c = { "clang-d" }
				},
				format_on_save = function(bufnr)
					-- Disable with a global or buffer-local variable
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
						return
					end
					return { timeout_ms = 500, lsp_fallback = true }
				end,
			})

			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					-- FormatDisable! will disable formatting just for this buffer
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
			end, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})

			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
			end, {
				desc = "Re-enable autoformat-on-save",
			})

			vim.api.nvim_create_user_command("Format", function(args)
				local range = nil
				if args.count ~= -1 then
					local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
					range = {
						start = { args.line1, 0 },
						["end"] = { args.line2, end_line:len() },
					}
				end
				require("conform").format({ async = true, lsp_fallback = true, range = range })
			end, { range = true })
		end
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
		}
	},
	{ "HiPhish/rainbow-delimiters.nvim" },
	{
		'nvim-lualine/lualine.nvim',
		dependencies = {
			'nvim-tree/nvim-web-devicons'
		},
		config = function()
			require('lualine').setup({
				options = {
					theme = "catppuccin",
					icons_enabled = true,
					component_separators = { left = '', right = '' },
					section_separators = { left = '', right = '' },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = false,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					}
				},
				sections = {
					lualine_a = { 'mode' },
					lualine_b = { 'branch', 'diff', 'diagnostics' },
					lualine_c = { 'filename' },
					lualine_x = { 'encoding', 'fileformat', 'filetype' },
					lualine_y = { 'searchcount', 'selectioncount', 'progress' },
					lualine_z = { 'location' }
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { 'filename' },
					lualine_x = { 'location' },
					lualine_y = {},
					lualine_z = {}
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {}
			})
		end
	},
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
	{
		"giusgad/pets.nvim",
		dependencies = { "MunifTanjim/nui.nvim", "giusgad/hologram.nvim" },
		require("pets").setup({
			row = 1,            -- the row (height) to display the pet at (higher row means the pet is lower on the screen), must be 1<=row<=10
			col = 0,            -- the column to display the pet at (set to high number to have it stay still on the right side)
			speed_multiplier = 1, -- you can make your pet move faster/slower. If slower the animation will have lower fps.
			default_pet = "dog", -- the pet to use for the PetNew command
			default_style = "brown", -- the style of the pet to use for the PetNew command
			random = true,      -- whether to use a random pet for the PetNew command, overrides default_pet and default_style
			death_animation = true, -- animate the pet's death, set to false to feel less guilt -- currently no animations are available
			popup = {           -- popup options, try changing these if you see a rectangle around the pets
				width = "30%",  -- can be a string with percentage like "45%" or a number of columns like 45
				winblend = 100, -- winblend value - see :h 'winblend' - only used if avoid_statusline is false
				hl = { Normal = "Normal" }, -- hl is only set if avoid_statusline is true, you can put any hl group instead of "Normal"
				avoid_statusline = false, -- if winblend is 100 then the popup is invisible and covers the statusline, if that
				-- doesn't work for you then set this to true and the popup will use hl and will be spawned above the statusline (hopefully)
			}
		})

	}


}
