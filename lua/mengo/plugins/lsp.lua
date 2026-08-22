return {
	{
		"saghen/blink.compat",
		-- use the latest release, via version = '*', if you also use the latest release for blink.cmp
		version = "*",
		-- lazy.nvim will automatically load the plugin when it's required by blink.cmp
		lazy = true,
		-- make sure to set opts so that lazy.nvim calls blink.compat's setup
		opts = {},
	},
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = {
			"moyiz/blink-emoji.nvim",
			"rafamadriz/friendly-snippets",
			"dmitmel/cmp-digraphs",
		},
		-- v2 is in development with breaking changes; stay on stable 1.x until it settles
		version = "1.*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide" },
				["<C-y>"] = { "select_and_accept" },

				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },

				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },

				["<Tab>"] = {},
				["<S-Tab>"] = {},
			},

			appearance = {
				-- use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			completion = {
				menu = {
					border = vim.g.border_style,
					min_width = 20,
					max_height = 15,
					scrollbar = false,
					draw = {
						columns = { { "label", "label_description", gap = 0 }, { "kind_icon", "kind" } },
						treesitter = { "lsp" },
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 0,
					window = {
						min_width = 15,
						max_width = 80,
						max_height = 25,
						border = vim.g.border_style,
					},
				},
			},
			-- experimental signature help support
			signature = {
				enabled = true,
				window = { border = vim.g.border_style },
			},
			snippets = {
				preset = "luasnip",
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "markdown", "emoji", "digraphs" },
				per_filetype = {
					markdown = {
						inherit_defaults = true,
						"obsidian",
						"obsidian_new",
						"obsidian_tags",
					},
				},
				providers = {
					lsp = { score_offset = 1000 }, -- extreme priority so fuzzy matches never bury real LSP results
					path = { score_offset = 3 },
					buffer = { score_offset = -150, min_keyword_length = 3 },
					snippets = {
						name = "Snippets",
						module = "blink.cmp.sources.snippets",
						score_offset = -100,
						min_keyword_length = 3,
					},
					markdown = {
						name = "RenderMarkdown",
						module = "render-markdown.integ.blink",
						fallbacks = { "lsp" },
					},
					digraphs = {
						name = "digraphs",
						module = "blink.compat.source",
						score_offset = -3,
						opts = {
							cache_digraphs_on_start = true,
						},
					},
					emoji = {
						module = "blink-emoji",
						name = "Emoji",
						score_offset = 15, -- Tune by preference
						opts = { insert = true }, -- Insert emoji (default) or complete its name
					},
					obsidian = {
						name = "obsidian",
						module = "blink.compat.source",
						score_offset = 20,
					},
					obsidian_new = {
						name = "obsidian_new",
						module = "blink.compat.source",
						score_offset = 20,
					},
					obsidian_tags = {
						name = "obsidian_tags",
						module = "blink.compat.source",
						score_offset = 20,
					},
				},
			},
		},
		-- allows extending the providers array elsewhere in your config
		-- without having to redefine it
		opts_extend = { "sources.default" },
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"saghen/blink.cmp",
			"j-hui/fidget.nvim",
			{
				"folke/lazydev.nvim",
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
		},

		config = function()
			require("fidget").setup({
				notification = {
					override_vim_notify = false,
				},
			})

			-- Server configs via native vim.lsp.config (merged with nvim-lspconfig defaults);
			-- mason-lspconfig v2 auto-enables every mason-installed server.
			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})

			vim.lsp.config("gopls", {
				settings = {
					gopls = {
						completeUnimported = true,
						usePlaceholders = true,
						analyses = {
							unusedparams = true,
						},
					},
				},
			})

			vim.lsp.config("clangd", {
				cmd = {
					"clangd",
					"--offset-encoding=utf-16",
				},
			})

			-- Foundry vs Hardhat settings, detected per-project at server start.
			-- before_init (not a startup-time computation) so :cd-ing between
			-- foundry/hardhat projects in one session picks the right settings.
			vim.lsp.config("solidity_ls_nomicfoundation", {
				before_init = function(_, config)
					local root = config.root_dir or vim.fn.getcwd()
					local is_foundry = vim.fn.filereadable(root .. "/foundry.toml") == 1
						or vim.fn.filereadable(root .. "/remappings.txt") == 1
					config.settings = is_foundry
							and {
								noHardHat = true,
								solidity = {
									packageDefaultDependenciesDirectory = "lib",
									formatter = "forge fmt",
								},
							}
						or {
							solidity = {
								includePath = "",
								remapping = {},
							},
						}
				end,
			})

			-- Single source of truth for what Mason installs: add an LSP server here
			-- (and, if it needs settings, a vim.lsp.config() call above) and it's
			-- covered; formatters mirror conform's formatters_by_ft (plugins/init.lua).
			-- rustfmt is excluded — it comes from rustup, not Mason.
			local servers =
				{ "lua_ls", "rust_analyzer", "clangd", "ts_ls", "pyright", "solidity_ls_nomicfoundation", "gopls" }
			local formatters = { "stylua", "prettier", "black", "isort", "ruff", "clang-format" }
			local ensure_installed = {}
			vim.list_extend(ensure_installed, servers)
			vim.list_extend(ensure_installed, formatters)

			require("mason").setup()
			require("mason-tool-installer").setup({
				ensure_installed = ensure_installed,
				auto_update = true,
				debounce_hours = 12,
			})
			require("mason-lspconfig").setup({
				-- eslint-lsp is installed in mason but eslint runs via nvim-lint (eslint_d);
				-- exclude it so diagnostics don't double-report
				automatic_enable = { exclude = { "eslint" } },
			})

			vim.diagnostic.config({
				virtual_text = false,
				update_in_insert = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = true,
					header = "",
					prefix = "",
				},
			})
		end,
	},
}
