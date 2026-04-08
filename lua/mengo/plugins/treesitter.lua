return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-context",
			{ "nushell/tree-sitter-nu", build = ":TSUpdate nu" },
		},

		config = function()
			require("nvim-treesitter").setup({})

			-- Install parsers
			require("nvim-treesitter").install({
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"rust",
				"javascript",
				"typescript",
				"tsx",
				"jsx",
				"prisma",
				"solidity",
				"bash",
				"go",
				"xml",
				"http",
				"json",
				"graphql",
				"java",
				"markdown",
				"markdown_inline",
				"yaml",
				"toml",
				"sql",
				"gitcommit",
				"git_rebase",
				"diff",
			})

			-- Enable treesitter highlighting and indentation for all filetypes
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local buf = args.buf
					-- Skip oil buffers
					if vim.bo[buf].filetype == "oil" then
						return
					end
					-- Skip large files
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return
					end
					-- Enable treesitter highlighting
					pcall(vim.treesitter.start, buf)
					-- Enable treesitter indentation
					vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
				max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
				min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
				line_numbers = true,
				multiline_threshold = 20, -- Maximum number of lines to show for a single context
				trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
				mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
				-- Separator between context and content. Should be a single character string, like '-'.
				-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
				separator = nil,
				zindex = 20, -- The Z-index of the context window
				on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
			})
		end,
	},
	-- {
	--   "nvim-treesitter/nvim-treesitter-textobjects",
	--   config = function()
	--     require("nvim-treesitter.configs").setup({
	--       textobjects = {
	--         select = {
	--           enable = true,
	--
	--           -- Automatically jump forward to textobj, similar to targets.vim
	--           lookahead = true,
	--
	--           keymaps = {
	--             -- You can use the capture groups defined in textobjects.scm
	--             ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
	--             ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
	--             ["=l"] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
	--             ["=r"] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },
	--
	--             ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
	--             ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },
	--
	--             ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
	--             ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },
	--
	--             ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
	--             ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },
	--
	--             ["af"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
	--             ["if"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },
	--
	--             ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
	--             ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
	--           },
	--         },
	--         swap = {
	--           enable = true,
	--           swap_next = {
	--             ["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
	--           },
	--           swap_previous = {
	--             ["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with prev
	--           },
	--         },
	--
	--       }
	--     })
	--   end
	-- },
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
		config = function()
			local tsj = require("treesj")

			local langs = { --[[ configuration for languages ]]
			}

			tsj.setup({
				---@type boolean Use default keymaps (<space>m - toggle, <space>j - join, <space>s - split)
				use_default_keymaps = false,
				---@type boolean Node with syntax error will not be formatted
				check_syntax_error = true,
				---If line after join will be longer than max value,
				---@type number If line after join will be longer than max value, node will not be formatted
				max_join_length = 120,
				---Cursor behavior:
				---hold - cursor follows the node/place on which it was called
				---start - cursor jumps to the first symbol of the node being formatted
				---end - cursor jumps to the last symbol of the node being formatted
				---@type 'hold'|'start'|'end'
				cursor_behavior = "hold",
				---@type boolean Notify about possible problems or not
				notify = true,
				---@type boolean Use `dot` for repeat action
				dot_repeat = true,
				---@type nil|function Callback for treesj error handler. func (err_text, level, ...other_text)
				on_error = nil,
				---@type table Presets for languages
				-- langs = {}, -- See the default presets in lua/treesj/langs
			})

			-- TreeSJ
			vim.keymap.set("n", "<leader>m", require("treesj").toggle)
			-- For extending default preset with `recursive = true`
			vim.keymap.set("n", "<leader>M", function()
				tsj.toggle({ split = { recursive = true } })
			end)
		end,
	},
}
