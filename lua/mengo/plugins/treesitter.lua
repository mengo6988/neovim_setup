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

			-- Auto-install missing parsers on file open
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local ft = vim.bo[args.buf].filetype
					local lang = vim.treesitter.language.get_lang(ft)
					if lang and not pcall(vim.treesitter.language.inspect, lang) then
						require("nvim-treesitter").install(lang)
					end
				end,
			})

			-- Pre-install parsers for common languages
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
				"css",
				"scss",
				"html",
				"python",
				"cpp",
				"dockerfile",
				"make",
				"regex",
				"jsonc",
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
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		keys = {
			{ "<leader>m", function() require("treesj").toggle() end, desc = "TreeSJ Toggle" },
			{ "<leader>M", function() require("treesj").toggle({ split = { recursive = true } }) end, desc = "TreeSJ Toggle Recursive" },
		},
		opts = {
			use_default_keymaps = false,
			max_join_length = 120,
		},
	},
}
