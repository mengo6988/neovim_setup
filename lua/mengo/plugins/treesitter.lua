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

			-- Neovim has no builtin .prisma filetype detection
			vim.filetype.add({ extension = { prisma = "prisma" } })

			-- No jsonc parser on the main branch; the json parser handles it
			vim.treesitter.language.register("json", "jsonc")

			-- Auto-install missing parsers on file open
			local skip_ft = { oil = true, help = true, qf = true, lazy = true, mason = true, TelescopePrompt = true }
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local buf = args.buf
					-- Skip special/plugin buffers
					if vim.bo[buf].buftype ~= "" then
						return
					end
					local ft = vim.bo[buf].filetype
					if skip_ft[ft] then
						return
					end
					local lang = vim.treesitter.language.get_lang(ft)
					if lang and not pcall(vim.treesitter.language.inspect, lang) then
						pcall(require("nvim-treesitter").install, lang)
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

			-- Catch buffers already open before this config ran (startup file / :Lazy reload)
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= "" then
					vim.api.nvim_exec_autocmds("FileType", { buffer = buf })
				end
			end
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
