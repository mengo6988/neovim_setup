return {

	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,

	config = function()
		require("catppuccin").setup({
			flavour = "mocha", -- latte, frappe, macchiato, mocha
			background = { -- :h background
				light = "latte",
				dark = "mocha",
			},
			transparent_background = true, -- disables setting the background color.
			show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
			term_colors = false,  -- sets terminal colors (e.g. `g:terminal_color_0`)
			dim_inactive = {
				enabled = false,  -- dims the background color of inactive window
				shade = "dark",
				percentage = 0.01, -- percentage of the shade to apply to the inactive window
			},
			no_italic = false,    -- Force no italic
			no_bold = false,      -- Force no bold
			no_underline = false, -- Force no underline
			styles = {            -- Handles the styles of general hi groups (see `:h highlight-args`):
				comments = { "italic" }, -- Change the style of comments
				conditionals = { "italic" },
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
				operators = {},
			},
			color_overrides = {},
			custom_highlights = {},
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				notify = false,
        noice = false,
				rainbow_delimiters = true,
				indent_blankline = {
					enabled = true,
					scope_color = "lavender", -- catppuccin color (eg. `lavender`) Default: text
					colored_indent_levels = false,
				},
				mini = {
					enabled = true,
					indentscope_color = "",
				},
				lsp_trouble = false,
				which_key = false,
				telescope = {
					enabled = true,
				},
				harpoon = false,
				bufferline = true,
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
					},
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
					},
					inlay_hints = {
						background = true,
					},
				},
				leap = false,
				ufo = true,
        blink_cmp = false,



				-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
			},
		})

		-- setup must be called before loading
		vim.cmd.colorscheme "catppuccin"
	end
}
