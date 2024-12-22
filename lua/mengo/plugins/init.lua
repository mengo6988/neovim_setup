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
          lua = { "stylua" },
          python = function(bufnr)
            if require("conform").get_formatter_info("ruff_format", bufnr).available then
              return { "ruff_format" }
            else
              return { "isort", "black" }
            end
          end,
          javascript = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          javascriptreact = { "prettier" },
          rust = { "rustfmt" },
          cpp = { "clang-format" },
          c = { "clang-format" },
          java = { "clang-format" },
          json = { "prettier" },

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
          lualine_c = { { 'filename', file_status = true, path = 1 } },
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
      -- { "<C-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
      -- { "<C-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
      -- { "<C-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
      -- { "<C-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
      -- { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  -- {
  -- 	"giusgad/pets.nvim",
  -- 	dependencies = { "MunifTanjim/nui.nvim", "giusgad/hologram.nvim" },
  -- 	config = function()
  -- 		require("pets").setup({
  -- 		row = 1,            -- the row (height) to display the pet at (higher row means the pet is lower on the screen), must be 1<=row<=10
  -- 		col = 0,            -- the column to display the pet at (set to high number to have it stay still on the right side)
  -- 		speed_multiplier = 1, -- you can make your pet move faster/slower. If slower the animation will have lower fps.
  -- 		default_pet = "dog", -- the pet to use for the PetNew command
  -- 		default_style = "brown", -- the style of the pet to use for the PetNew command
  -- 		random = true,      -- whether to use a random pet for the PetNew command, overrides default_pet and default_style
  -- 		death_animation = true, -- animate the pet's death, set to false to feel less guilt -- currently no animations are available
  -- 		popup = {           -- popup options, try changing these if you see a rectangle around the pets
  -- 			width = "30%",  -- can be a string with percentage like "45%" or a number of columns like 45
  -- 			winblend = 100, -- winblend value - see :h 'winblend' - only used if avoid_statusline is false
  -- 			hl = { Normal = "Normal" }, -- hl is only set if avoid_statusline is true, you can put any hl group instead of "Normal"
  -- 			avoid_statusline = false, -- if winblend is 100 then the popup is invisible and covers the statusline, if that
  -- 			-- doesn't work for you then set this to true and the popup will use hl and will be spawned above the statusline (hopefully)
  -- 		}
  -- 	})
  -- 	end
  --
  -- }
  {
    "mg979/vim-visual-multi"
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  {
    'ggandor/leap.nvim',
    dependencies = { 'tpope/vim-repeat' },
    config = function()
      require('leap').create_default_mappings()
      local leap = require('leap')
      leap.opts.case_sensitive = false
      leap.opts.equivalence_classes = { ' \t\r\n', }
      leap.opts.max_phase_one_targets = nil
      leap.opts.highlight_unlabeled_phase_one_targets = false
      leap.opts.max_highlighted_traversal_targets = 10
      leap.opts.substitute_chars = {}
      leap.opts.safe_labels = 'sfnut/SFNLHMUGTZ?'
      leap.opts.labels = 'sfnjklhodweimbuyvrgtaqpcxz/SFNJKLHODWEIMBUYVRGTAQPCXZ?'
      leap.opts.special_keys = {
        next_target = '<enter>',
        prev_target = '<tab>',
        next_group = '<space>',
        prev_group = '<tab>',
      }
    end
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      signs = true,      -- show icons in the signs column
      sign_priority = 8, -- sign priority
      -- keywords recognized as todo comments
      keywords = {
        FIX = {
          icon = " ", -- icon used for the sign, and in search results
          color = "error", -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      gui_style = {
        fg = "NONE",         -- The gui style to use for the fg highlight group.
        bg = "BOLD",         -- The gui style to use for the bg highlight group.
      },
      merge_keywords = true, -- when true, custom keywords will be merged with the defaults
      -- highlighting of the line containing the todo comment
      -- * before: highlights before the keyword (typically comment characters)
      -- * keyword: highlights of the keyword
      -- * after: highlights after the keyword (todo text)
      highlight = {
        multiline = true,                -- enable multine todo comments
        multiline_pattern = "^.",        -- lua pattern to match the next multiline from the start of the matched keyword
        multiline_context = 10,          -- extra lines that will be re-evaluated when changing a line
        before = "",                     -- "fg" or "bg" or empty
        keyword = "wide",                -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = "fg",                    -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
        comments_only = true,            -- uses treesitter to match keywords in comments only
        max_line_len = 400,              -- ignore lines longer than this
        exclude = {},                    -- list of file types to exclude highlighting
      },
      -- list of named colors where we try to extract the guifg from the
      -- list of highlight groups or use the hex color if hl not found as a fallback
      colors = {
        error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
        info = { "DiagnosticInfo", "#2563EB" },
        hint = { "DiagnosticHint", "#10B981" },
        default = { "Identifier", "#7C3AED" },
        test = { "Identifier", "#FF00FF" }
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        -- regex that will be used to match keywords.
        -- don't replace the (KEYWORDS) placeholder
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
      },
    }

  },
  {
    "leath-dub/snipe.nvim",
    keys = {
      { "gb", function() require("snipe").open_buffer_menu() end, desc = "Open Snipe buffer menu" }
    },
    opts = {}
  },
  {
    'brianhuster/live-preview.nvim',
    dependencies = {

      -- You can choose one of the following pickers
      'nvim-telescope/telescope.nvim',
    },
    opts = {
      cmd = "LivePreview", -- Main command of live-preview.nvim
      port = 5500,        -- Port to run the live preview server on.
      autokill = false,   -- If true, the plugin will autokill other processes running on the same port (except for Neovim) when starting the server.
      browser = 'default', --~/.co- Terminal command to open the browser for live-previewing (eg. 'firefox', 'flatpak run com.vivaldi.Vivaldi'). By default, it will use the default browser.
      dynamic_root = false, -- If true, the plugin will set the root directory to the previewed file's directory. If false, the root directory will be the current working directory (`:lua print(vim.uv.cwd())`).
      sync_scroll = false, -- If true, the plugin will sync the scrolling in the browser as you scroll in the Markdown files in Neovim.
      picker = nil,       -- Picker to use for opening files. 3 choices are available: 'telescope', 'fzf-lua', 'mini.pick'. If nil, the plugin look for the first available picker when you call the `pick` command.
    },
  },
  { 'wakatime/vim-wakatime',          lazy = false },
}
