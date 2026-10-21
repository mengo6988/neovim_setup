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

			-- augroup so :Lazy reload replaces these autocmds instead of stacking duplicates
			local group = vim.api.nvim_create_augroup("mengo-treesitter", { clear = true })

			-- Auto-install missing parsers on file open
			local skip_ft = { oil = true, help = true, qf = true, lazy = true, mason = true, TelescopePrompt = true }
			local available ---@type table<string, true>?
			vim.api.nvim_create_autocmd("FileType", {
				group = group,
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
					if not lang or pcall(vim.treesitter.language.inspect, lang) then
						return
					end
					-- only languages nvim-treesitter knows, or install() warns "skipping unsupported language" every time
					if not available then
						available = {}
						for _, l in ipairs(require("nvim-treesitter").get_available()) do
							available[l] = true
						end
					end
					if available[lang] then
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
				group = group,
				callback = function(args)
					local buf = args.buf
					-- Skip oil buffers
					if vim.bo[buf].filetype == "oil" then
						return
					end
					-- Skip treesitter on large files (512 KB)
					local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
					local too_big = ok and stats and stats.size > 512 * 1024
					local started = not too_big and pcall(vim.treesitter.start, buf)
					-- foldmethod is window-local: set it every time or the window keeps the last buffer's value.
					-- Big files get manual, since the global treesitter foldexpr would parse them anyway.
					local win = vim.fn.bufwinid(buf)
					if win ~= -1 then
						vim.wo[win][0].foldmethod = started and "expr" or (too_big and "manual" or "indent")
					end
					-- TS indent only where an indents query exists; everything else keeps its Vim indent script
					local lang = started and vim.treesitter.language.get_lang(vim.bo[buf].filetype)
					if lang and vim.treesitter.query.get(lang, "indents") then
						vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
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
		-- main branch matches nvim-treesitter's main branch API above; master
		-- (the lazy-lock default) targets the old pre-rewrite nvim-treesitter and
		-- errors on load, which is why mini.lua used to rtp-disable this plugin.
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		lazy = true, -- mini.ai and remap.lua's move maps require() it on demand
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = { lookahead = true },
				move = { set_jumps = true },
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		lazy = true, -- already a dependency of nvim-treesitter above, which is eager
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
