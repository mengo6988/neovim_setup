return {
	"obsidian-nvim/obsidian.nvim", -- maintained community fork (epwalsh/obsidian.nvim is archived)
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
	--   -- refer to `:h file-pattern` for more examples
	--   "BufReadPre path/to/my-vault/*.md",
	--   "BufNewFile path/to/my-vault/*.md",
	-- },
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",

		-- see below for full list of optional dependencies 👇
	},
	opts = {
		ui = {
			enable = false, -- Disable UI to avoid conflicts with render-markdown
		},
		workspaces = {
			{
				name = "zattlekasten",
				path = "~/Documents/obsidian/Zattelkasten",
			},
			{
				name = "work",
				path = "~/Documents/obsidian/vault",
			},
			{
				name = "learn",
				path = "~/Documents/obsidian/learn",
			},
		},

		daily_notes = {
			-- Optional, if you keep daily notes in a separate directory.
			folder = "notes/dailies",
			-- Optional, if you want to change the date format for the ID of daily notes.
			date_format = "%Y-%m-%d",
			-- Optional, if you want to change the date format of the default alias of daily notes.
			alias_format = "%B %-d, %Y",
			-- Optional, default tags to add to each new daily note created.
			default_tags = { "daily-notes" },
			-- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
			template = nil,
		},
		templates = {
			folder = "templates",
			date_format = "%Y-%m-%d-%a",
			time_format = "%H:%M",
		},
		legacy_commands = false, -- new form is `Obsidian <subcommand>`
		cache = { enabled = true }, -- off by default; speeds up pickers across three vaults

		frontmatter = {
			---@return table
			func = function(note)
				-- Add the title of the note as an alias.
				if note.title then
					note:add_alias(note.title)
				end

				local out = { id = note.id, aliases = note.aliases, tags = note.tags }

				-- `note.metadata` contains any manually added fields in the frontmatter.
				-- So here we just make sure those fields are kept in the frontmatter.
				if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
					for k, v in pairs(note.metadata) do
						out[k] = v
					end
				end

				return out
			end,
		},

		-- Completion comes from obsidian's own in-process LSP (obsidian-ls),
		-- which blink picks up through its `lsp` source. Defaults are fine.
	},

	init = function()
		-- 3.x sets <CR> (smart action), gf (via includeexpr), and ]o/[o itself.
		-- Only the checkbox toggle needs a keymap now; the old `mappings` option
		-- is inert and the util functions it called no longer exist.
		vim.api.nvim_create_autocmd("User", {
			pattern = "ObsidianNoteEnter",
			callback = function(ev)
				vim.keymap.set(
					"n",
					"<leader>ch",
					"<cmd>Obsidian toggle_checkbox<cr>",
					{ buffer = ev.buf, desc = "Obsidian: toggle checkbox" }
				)
			end,
		})
	end,
}
