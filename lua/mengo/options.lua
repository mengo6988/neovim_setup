local options = {
	backup = false, -- creates a backup file
	clipboard = "unnamedplus", -- allows neovim to access the system clipboard
	cmdheight = 1, -- noice owns messages/cmdline; no need for extra rows
	completeopt = { "menu", "menuone", "noselect" }, -- native ins-completion only; blink.cmp ignores this
	conceallevel = 2, -- so that `` is visible in markdown files
	fileencoding = "utf-8", -- the encoding written to a file
	hlsearch = true, -- highlight all matches on previous search pattern
	ignorecase = true, -- ignore case in search patterns
	-- mouse = "a",                           -- allow the mouse to be used in neovim
	pumheight = 10, -- pop up menu height
	showmode = false, -- we don't need to see things like -- INSERT -- anymore
	showtabline = 2, -- always show tabs
	smartcase = true, -- smart case
	smartindent = true, -- make indenting smarter again
	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go to the right of current window
	splitkeep = "screen", -- Keep text on same screen line (Neovim >=0.9)
	swapfile = false, -- creates a swapfile
	termguicolors = true, -- enable 24-bit truecolor (required for catppuccin)
	timeoutlen = 300, -- time to wait for a mapped sequence to complete (in milliseconds)
	undofile = true, -- enable persistent undo
	updatetime = 300, -- faster completion (4000ms default)
	writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	expandtab = true, -- convert tabs to spaces
	shiftwidth = 2, -- the number of spaces inserted for each indentation
	tabstop = 2, -- insert 2 spaces for a tab
	cursorline = false, -- highlight the current line
	number = true, -- set numbered lines
	relativenumber = true, -- set relative numbered lines
	numberwidth = 4, -- set number column width to 4 {default 4}
	foldlevel = 99, -- nvim-ufo owns folding (treesitter/indent providers)
	foldlevelstart = 99, -- nvim-ufo: start with all folds open
	foldenable = true,
	concealcursor = "nc", -- keep markdown conceal in normal/command mode

	smoothscroll = true, -- scroll by screen line through wrapped lines instead of jumping
	confirm = true, -- ask instead of erroring (E37) when :q/:bd with unsaved changes
	list = true, -- show invisible characters per listchars below
	listchars = { tab = "» ", trail = "·", nbsp = "␣" },

	signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
	wrap = true, -- display lines as one long line
	linebreak = true, -- companion to wrap, don't split words
	scrolloff = 8, -- minimal number of screen lines to keep above and below the cursor
	sidescrolloff = 8, -- minimal number of screen columns either side of cursor if wrap is `false`
	whichwrap = "bs<>[]hl", -- which "horizontal" keys are allowed to travel to prev/next line
	inccommand = "split", -- live preview of :s in a split
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

-- Autoformat-on-save is ON by default. Use :FormatDisable / :FormatDisable! to opt out.
-- vim.opt.shortmess = "ilmnrx"                        -- flags to shorten vim messages, see :help 'shortmess'
vim.opt.shortmess:append("c") -- don't give |ins-completion-menu| messages
vim.opt.iskeyword:append("-") -- hyphenated words recognized by searches
vim.opt.formatoptions:remove({ "c", "r", "o" }) -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.
vim.g.border_style = "rounded" ---@type "single"|"double"|"rounded"
-- 0.11+: default border for floats opened via nvim_open_win, incl. LSP hover,
-- signature help, and diagnostic floats. Plugins with their own border config
-- (blink, and anything else with its own border option) read vim.g.border_style.
vim.o.winborder = vim.g.border_style

-- Built-in ftplugins (e.g. python) bind ]m/[m/]]/[[ themselves; disable them so
-- the treesitter motions in remap.lua aren't shadowed.
vim.g.no_plugin_maps = true

-- ...which also silences matchit, so % stops jumping HTML tags / if-end pairs.
-- b:match_words is still set by the ftplugins; only the maps need restoring.
for mode, plug in pairs({ n = "Normal", x = "Visual", o = "Operation" }) do
	vim.keymap.set(mode, "%", "<Plug>(Matchit" .. plug .. "Forward)", { silent = true, remap = true })
	vim.keymap.set(mode, "g%", "<Plug>(Matchit" .. plug .. "Backward)", { silent = true, remap = true })
end

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Pick up files changed outside nvim (autoread only fires on these events)
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = vim.api.nvim_create_augroup("checktime-on-focus", { clear = true }),
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

-- Restore cursor to last known position on file open
vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("restore-cursor", { clear = true }),
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local lcount = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Open :help in a right-hand vertical split instead of a horizontal one
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("vertical-help", { clear = true }),
	pattern = "help",
	callback = function()
		vim.bo.bufhidden = "unload"
		vim.cmd.wincmd("L")
		vim.cmd.wincmd("=")
	end,
})
