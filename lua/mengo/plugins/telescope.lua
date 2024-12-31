return {
  {
    'nvim-telescope/telescope.nvim',

    dependencies = {
      'nvim-lua/plenary.nvim',
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },

    config = function()
      local custom_cursor_theme = {
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
      require('telescope').setup({
        defaults = {
          sorting_strategy = "ascending",

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
          grep_string = {
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
          },
          lsp_definitions = {
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
          },
          lsp_references = {
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
          },
          lsp_implementations = {
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
          },
          lsp_type_definitions = {
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
          },
          lsp_dynamic_workspace_symbols = {
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
          },
          lsp_document_symbols = {
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
          },
        },
        extensions = {
          fzf = {},
          -- media_files = {
          --   -- filetypes whitelist
          --   -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
          --   filetypes = { "png", "webp", "jpg", "jpeg", "ico", "pdf" },
          --   -- find command (defaults to `fd`)
          --   find_cmd = "rg"
          -- }
        }
      })
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("ui-select")
      -- pcall(require('telescope').load_extension, 'fzf')
      -- pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ph', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
      vim.keymap.set('n', '<leader>pb', builtin.builtin, {})
      vim.keymap.set('n', '<leader>pg', builtin.git_files, {})
      vim.keymap.set('n', '<leader>pt', builtin.treesitter, {})
      -- vim.keymap.set('n', '<leader>psw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>ps', builtin.live_grep, { desc = '[S]earch word' })
      vim.keymap.set('n', '<leader>psw', function()
        local word = vim.fn.expand("<cWORD>")
        builtin.grep_string({ search = word })
      end)
      vim.keymap.set('n', '<leader>pss', function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
      end)

      vim.keymap.set('n', '<leader>pr', require('telescope').extensions.flutter.commands,
        { desc = 'Open command Flutter' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>psn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })

      vim.keymap.set('n', '<leader>psp', function()
        builtin.find_files { cwd = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy') }
      end, { desc = '[S]earch [P]ackages' })

      require("mengo.telescope.multigrep").setup()
    end
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    dependencies = {
      "nvim-telescope/telescope.nvim"
    },
    config = function()
      -- This is your opts table
      require("telescope").setup {
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
              -- even more opts
            }

            -- pseudo code / specification for writing custom displays, like the one
            -- for "codeactions"
            -- specific_opts = {
            --   [kind] = {
            --     make_indexed = function(items) -> indexed_items, width,
            --     make_displayer = function(widths) -> displayer
            --     make_display = function(displayer) -> function(e)
            --     make_ordinal = function(e) -> string
            --   },
            --   -- for example to disable the custom builtin "codeactions" display
            --      do the following
            --   codeactions = false,
            -- }
          }
        }
      }
      -- To get ui-select loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      require("telescope").load_extension("ui-select")
    end
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
      { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
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
