return {
  {
    'saghen/blink.compat',
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    version = '*',
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets', 'dmitmel/cmp-digraphs' },
    version = 'v0.*',
    ---@module 'blink.cmp'
    -- -@type blink.cmp.Config
    opts = {
      keymap = { preset = 'default' },

      appearance = {
        -- use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },
      completion = {
        menu = {
          border = vim.g.border_style,
          min_width = 20,
          max_height = 15,
          scrollbar = false,
          columns = { { "label", "label_description", gap = 0 }, { "kind_icon", "kind" } },
          draw = {
            treesitter = { 'lsp' },
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
          }
        },
      },
      providers = {
        digraphs = {
          name = 'digraphs',
          module = 'blink.compat.source',
          score_offset = -3,
          opts = {
            cache_digraphs_on_start = true,
          }
        }
      },
      -- experimental signature help support
      signature = {
        enabled = true,
        border = vim.g.border_style
      },
      snippets = {
        expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
        active = function(filter)
          if filter and filter.direction then
            return require('luasnip').jumpable(filter.direction)
          end
          return require('luasnip').in_snippet()
        end,
        jump = function(direction) require('luasnip').jump(direction) end,
      },
      sources = {
        default = { 'lsp', 'path', 'luasnip', 'snippets', 'buffer', 'digraphs' },
      },
    },
    -- allows extending the providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = { "sources.default" }
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      'saghen/blink.cmp',
      -- 'hrsh7th/cmp-nvim-lsp',
      -- 'hrsh7th/cmp-buffer',
      -- 'hrsh7th/cmp-path',
      -- 'hrsh7th/cmp-cmdline',
      -- 'hrsh7th/nvim-cmp',
      -- 'L3MON4D3/LuaSnip',
      -- 'saadparwaiz1/cmp_luasnip',
      'j-hui/fidget.nvim',
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
      -- local cmp_lsp = require("cmp_nvim_lsp")
      -- local capabilities = vim.tbl_deep_extend(
      --   "force",
      --   {},
      --   vim.lsp.protocol.make_client_capabilities(),
      --   cmp_lsp.default_capabilities())
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      require("fidget").setup({})
      require("mason").setup()
      require('java').setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "rust_analyzer",
          "clangd",
          "ts_ls",
          "pyright",
          "solidity_ls_nomicfoundation",
          "gopls",
        },
        handlers = {
          function(server_name) -- default handler (optional)
            require("lspconfig")[server_name].setup {
              capabilities = capabilities
            }
          end,
          -- Settings for lua to set vim as global
          ["lua_ls"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup {
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { "vim" }
                  }
                }
              }
            }
          end,
          ["gopls"] = function()
            local lspconfig = require("lspconfig")
            local util = require "lspconfig/util"
            lspconfig.gopls.setup {
              capabilities = capabilities,
              cmd = { "gopls" },
              filetypes = { "go", "gomod", "gowork", "gotmpl" },
              root_dir = util.root_pattern("go.work", "go.mod", ".git"),
              settings = {
                gopls = {
                  completeUnimported = true,
                  usePlaceholders = true,
                  analyses = {
                    unusedparams = true,
                  },
                },
              }, }
          end,
          ["clangd"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.clangd.setup {
              capabilities = capabilities,
              cmd = {
                "clangd",
                "--offset-encoding=utf-16",
              },
            }
          end
        }
      })
      local kind_icons = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = " ",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "",
        Event = "",
        Operator = "󰆕",
        TypeParameter = " ",
        Misc = " ",
      }

      local lsp = vim.lsp
      lsp.handlers["textDocument/hover"] = lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      -- local cmp = require('cmp')
      -- local cmp_select = { behavior = cmp.SelectBehavior.Select }
      -- local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      -- cmp.setup({
      --   snippet = {
      --     -- REQUIRED -must specify a snipper engine
      --     expand = function(args)
      --       require('luasnip').lsp_expand(args.body)
      --     end,
      --   },
      --   window = {
      --     -- completion = cmp.config.window.bordered(),
      --     documentation = {
      --       border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      --     },
      --   },
      --   mapping = {
      --     ['<C-Space>'] = cmp.mapping.complete(),
      --     ['<C-u>'] = cmp.mapping.scroll_docs(4),
      --     ['<C-i>'] = cmp.mapping.scroll_docs(-4),
      --     ['<C-e>'] = cmp.mapping.abort(),
      --     ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
      --     ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
      --     ["<C-y>"] = cmp.mapping(
      --       cmp.mapping.confirm {
      --         behavior = cmp.ConfirmBehavior.Insert,
      --         select = true,
      --       },
      --       { "i", "c" }
      --     ),
      --   },
      --
      --   -- ['<Tab>'] = cmp.mapping(function(fallback)
      --   -- 	if cmp.visible() then
      --   -- 		cmp.select_next_item()
      --   -- 	else
      --   -- 		fallback()
      --   -- 	end
      --   -- end, { "i", "s", }),
      --   -- ['<S-Tab>'] = cmp.mapping(function(fallback)
      --   -- 	if cmp.visible() then
      --   -- 		cmp.select_prev_item()
      --   -- 	else
      --   -- 		fallback()
      --   -- 	end
      --   -- end, { "i", "s", }),
      --   formatting = {
      --     fields = { "kind", "abbr", "menu" },
      --     format = function(entry, vim_item)
      --       -- Kind icons
      --       vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
      --       -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      --       vim_item.menu = ({
      --         nvim_lsp = "[LSP]",
      --         luasnip = "[Snippet]",
      --         buffer = "[Buffer]",
      --         path = "[Path]",
      --       })[entry.source.name]
      --       return vim_item
      --     end,
      --   },
      --   sources = {
      --     { name = 'nvim_lsp' },
      --     { name = 'luasnip' },
      --     { name = 'buffer' },
      --     { name = 'path' },
      --   }
      -- })
      --
      -- cmp.event:on(
      --   'confirm_done',
      --   cmp_autopairs.on_confirm_done()
      -- )
      --
      -- cmp.setup.filetype({ "sql" }, {
      --   sources = {
      --     { name = "vim-dadbod-completion" },
      --     { name = "buffer" },
      --   },
      -- })

      local ls = require "luasnip"
      ls.config.set_config {
        history = false,
        updateevents = "TextChanged,TextChangedI",
      }
      for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/custom/snippets/*.lua", true)) do
        loadfile(ft_path)()
      end

      vim.keymap.set({ "i", "s" }, "<c-j>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { silent = true })

      vim.keymap.set({ "i", "s" }, "<c-k>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true })

      vim.diagnostic.config({
        virtual_text = false,
        update_in_insert = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })
      require("luasnip.loaders.from_vscode").lazy_load()
    end
  }
}
