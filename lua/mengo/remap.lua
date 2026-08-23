-- Shorten function name
local keymap = vim.keymap.set

-- Remap space as leader key
keymap("", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

--  Plugin related
keymap("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory (Oil)" })
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
keymap("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "Make it rain" })
keymap("n", "<leader>bd", function()
	Snacks.bufdelete()
end, { desc = "Delete buffer" })
keymap("n", "<leader>bo", function()
	Snacks.bufdelete.other()
end, { desc = "Close other buffers" })
keymap("n", "<leader>ibl", function()
	if Snacks.indent.enabled then
		Snacks.indent.disable()
	else
		Snacks.indent.enable()
	end
end, { desc = "Indent guides toggle" })
keymap("n", "<leader>z", function()
	Snacks.zen()
end, { desc = "Zen mode" })
keymap("n", "<leader>f", "<cmd>:Format<CR>", { desc = "Format" })
keymap("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "Open parent directory" })
keymap("n", "<leader>db", "<CMD>DBUIToggle<CR>", { desc = "[D][B]UI Toggle" })
keymap("n", "<leader>np", "<CMD>NoNeckPain<CR>", { desc = "No[N]eck[Pain]" })
keymap("n", "<leader>nl", "<CMD>Noice last<CR>", { desc = "[N]oice [L]ast" })
keymap("n", "<leader>nd", "<CMD>Noice dismiss<CR>", { desc = "[N]oice [D]ismiss" })
keymap("n", "<leader>nh", "<CMD>Noice history<CR>", { desc = "[N]oice [H]istory" })
keymap("n", "<leader>on", "<CMD>Nvumi<CR>", { desc = "[O]pen [N]vumi" })

keymap("n", "<leader>so", ":source %<CR>", { desc = "Source current file" })
keymap(
	"n",
	"<leader>rw",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word under cursor" }
)

-- Terminal related
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
keymap("t", "<C-d>", function()
	local term = vim.b.snacks_terminal
	if term and term.cmd then
		local cmd = type(term.cmd) == "table" and table.concat(term.cmd, " ") or tostring(term.cmd)
		if cmd:find("lazygit") then
			return "<C-d>"
		end
	end
	return "<C-\\><C-n><cmd>bd!<CR>"
end, { expr = true, desc = "Exit terminal mode" })
keymap("n", "<leader>st", function()
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 17)

	vim.g.last_term_job_id = vim.bo.channel
end, { desc = "Open terminal in bottom split" })
-- Save quit etc
-- <leader>w kept prefix-free so saving is instant (no timeoutlen wait)
keymap("n", "<leader>w", ":w!<CR>", { silent = true, desc = "Write file" })
keymap("n", "<leader>W", "<cmd>FormatEnable<CR><cmd>w<cr><cmd>FormatDisable<CR>", { desc = "Write with format" })
keymap("n", "<leader>x", ":x!<CR>", { silent = true, desc = "Write and quit" })
keymap("n", "<leader>q", ":q!<CR>", { silent = true, desc = "Quit (force)" })

-- keymap("n", "]c", "<cmd>cnext<CR>", { desc = "[C]uikfix Next" })
-- keymap("n", "[c", "<cmd>cprev<CR>", { desc = "[C]uikfix Prev" })

-- Quickfix
keymap("n", "]q", "<cmd>cnext<CR>zz", { desc = "Quickfix next" })
keymap("n", "[q", "<cmd>cprev<CR>zz", { desc = "Quickfix prev" })
keymap("n", "<leader>qo", "<cmd>copen<CR>", { desc = "[Q]uickfix [O]pen" })
keymap("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "[Q]uickfix [C]lose" })

-- Swap window layout (mnemonic: <C-w>H / <C-w>K)
keymap("n", "<leader>H", "<C-w>t<C-w>H", { noremap = true, silent = true, desc = "Swap to vertical layout" })
keymap("n", "<leader>K", "<C-w>t<C-w>K", { noremap = true, silent = true, desc = "Swap to horizontal layout" })

-- Vertical Splits
keymap("n", "<leader>v", ":vsplit<CR>", { silent = true, desc = "Vertical split" })
keymap("n", "<leader>s", ":split<CR>", { silent = true, desc = "Horizontal split" })
keymap("n", "<leader>,", ":only<CR>", { noremap = true, silent = true, desc = "Focus" })
keymap("n", "<leader>c", ":close<CR>", { noremap = true, silent = true, desc = "Close" })

-- Special Remaps
keymap("n", "gV", "`[v`]", { noremap = true, desc = "Select last changed or yanked text" })
-- mini.operators takes gx for exchange; builtin open-URL/file moves to gX
keymap(
	{ "n", "x" },
	"gX",
	require("mengo.open_link").open_link,
	{ desc = "Open URL/file under cursor (markdown/paren aware)" }
)
keymap("n", "yc", "yy<cmd>normal gcc<CR>p", { desc = "Copy paste and comment the line copied" })
keymap("n", "<C-s><C-s>", ":.!sh<cr>", { noremap = true, desc = "Send current line to sh and REPLACE with the output" })
keymap("i", "jk", "<Esc>", { silent = true, desc = "Exit insert mode" })

-- Better navigation
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up (display line)" })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down (display line)" })

-- Better File Navigation
keymap("n", "<C-d>", "<C-d>zz", { silent = true, desc = "Half page down (centered)" })
keymap("n", "<C-u>", "<C-u>zz", { silent = true, desc = "Half page up (centered)" })
keymap("n", "<C-f>", "<C-f>zz", { silent = true, desc = "Page down (centered)" })
keymap("n", "<C-b>", "<C-b>zz", { silent = true, desc = "Page up (centered)" })
keymap("n", "n", "nzz", { silent = true, desc = "Next search match (centered)" })
keymap("n", "N", "Nzz", { silent = true, desc = "Previous search match (centered)" })
keymap("n", "*", "*zz", { silent = true, desc = "Search word forward (centered)" })
keymap("n", "#", "#zz", { silent = true, desc = "Search word backward (centered)" })
keymap("n", "G", "Gzz", { silent = true, desc = "End of file (centered)" })

-- Resize with arrows
keymap("n", "<C-S-Up>", ":resize +2<CR>", { silent = true, desc = "Increase window height" })
keymap("n", "<C-S-Down>", ":resize -2<CR>", { silent = true, desc = "Decrease window height" })
keymap("n", "<C-S-Left>", ":vertical resize +2<CR>", { silent = true, desc = "Widen window" })
keymap("n", "<C-S-Right>", ":vertical resize -2<CR>", { silent = true, desc = "Narrow window" })

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", { silent = true, desc = "Next buffer" })
keymap("n", "<S-h>", ":bprevious<CR>", { silent = true, desc = "Previous buffer" })

-- Move text up and down
keymap("n", "<M-j>", ":m .+1<CR>==", { silent = true, desc = "Move line down" })
keymap("n", "<M-k>", ":m .-2<CR>==", { silent = true, desc = "Move line up" })

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv^", { silent = true, desc = "Outdent (keep selection)" })
keymap("v", ">", ">gv^", { silent = true, desc = "Indent (keep selection)" })
keymap("v", "<leader>y", '"+y', { silent = true, desc = "Yank to system clipboard" })

-- Move text up and down
keymap("v", "<M-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })
keymap("v", "<M-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
keymap("v", "p", '"_dP', { silent = true, desc = "Paste without overwriting register" })

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
keymap("x", "K", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })
keymap("x", "<M-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
keymap("x", "<M-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })

-- Toggle diagnostics display. tiny-inline-diagnostic renders itself regardless
-- of the virtual_text option, so flipping virtual_text alone no longer does
-- anything visible — toggle the plugin directly, falling back to the native
-- diagnostics on/off switch if it's ever not loaded.
keymap("n", "<leader>vt", function()
	local ok, tid = pcall(require, "tiny-inline-diagnostic")
	if ok and tid.toggle then
		tid.toggle()
		return
	end
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics display" })

-- Copy the current line's diagnostic messages to the clipboard
-- (dmmulroy uses <leader>cd, but <leader>c is a standalone "close window" map
-- here and adding a longer <leader>c* map would make it wait out timeoutlen)
vim.keymap.set("n", "<leader>yd", function()
	local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
	local diagnostics = vim.diagnostic.get(0, { lnum = lnum })
	if #diagnostics == 0 then
		vim.notify("No diagnostics on the current line.")
		return
	end
	local messages = vim.tbl_map(function(d)
		return d.message
	end, diagnostics)
	vim.fn.setreg("+", table.concat(messages, "\n"))
	vim.notify("Diagnostics copied to clipboard.")
end, { desc = "[Y]ank line [D]iagnostics to clipboard" })

-- LSP attach for lsp commands

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
	callback = function(event)
		local bufnr = event.buf
		local bufname = vim.api.nvim_buf_get_name(bufnr)
		-- Detach from non-file buffers (diffview, fugitive, etc.)
		if bufname == "" or bufname:match("^diffview://") or bufname:match("^fugitive://") then
			vim.schedule(function()
				vim.lsp.buf_detach_client(bufnr, event.data.client_id)
			end)
			return
		end

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- Jump to the definition of the word under your cursor.
		--  This is where a variable was first declared, or where a function is defined, etc.
		--  To jump back, press <C-t>.
		map("gd", function()
			require("telescope.builtin").lsp_definitions()
			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
		end, "[G]oto [D]efinition")
		-- Find references for the word under your cursor.
		map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

		-- Jump to the implementation of the word under your cursor.
		--  Useful when your language has ways of declaring types without an actual implementation.
		map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

		-- Jump to the type of the word under your cursor.
		--  Useful when you're not sure what type a variable is and you want to see
		--  the definition of its *type*, not where it was *defined*.
		map("<leader>vD", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

		-- Fuzzy find all the symbols in your current document.
		--  Symbols are things like variables, functions, types, etc.
		map("<leader>vds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

		-- Fuzzy find all the symbols in your current workspace.
		--  Similar to document symbols, except searches over your entire project.
		map("<leader>vws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
		map("<leader>vd", function()
			vim.diagnostic.open_float()
		end, "[D]iagnostic Float")

		-- Rename the variable under your cursor with live preview (inc-rename).
		--  Most Language Servers support renaming across files, etc.
		vim.keymap.set("n", "<leader>vrn", function()
			return ":IncRename " .. vim.fn.expand("<cword>")
		end, { buffer = event.buf, expr = true, desc = "LSP: [R]e[n]ame" })
		map("<leader>vh", function()
			vim.lsp.buf.signature_help()
		end, "Signature [Help]")

		-- Execute a code action, usually your cursor needs to be on top of an error
		-- or a suggestion from your LSP for this to activate.
		map("<leader>vca", vim.lsp.buf.code_action, "[C]ode [A]ction")

		-- Opens a popup that displays documentation about the word under your cursor
		--  See `:help K` for why this keymap.
		map("K", function()
			vim.lsp.buf.hover()
		end, "Hover Documentation")

		-- WARN: This is not Goto Definition, this is Goto Declaration.
		--  For example, in C this would take you to the header.
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

		map("<leader>vwa", vim.lsp.buf.add_workspace_folder, "add workspace folder")
		map("<leader>vwr", vim.lsp.buf.remove_workspace_folder, "rm workspace folder")
		map("<leader>vwl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, "[W]orkspace Folder [L]ist")

		-- Diagnostic navigation
		map("[d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, "Previous [D]iagnostic")
		map("]d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, "Next [D]iagnostic")
		map("[e", function()
			vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR })
		end, "Previous [E]rror")
		map("]e", function()
			vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR })
		end, "Next [E]rror")
		map("[w", function()
			vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.WARN })
		end, "Previous [W]arning")
		map("]w", function()
			vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.WARN })
		end, "Next [W]arning")

		-- Inlay hints
		if client and client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
		end
		map("<leader>ih", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
		end, "Toggle [I]nlay [H]ints")
	end,
})

-- Yank with path
local yank = require("mengo.yank")

-- Normal mode (operator-pending): <leader>ya{motion}, <leader>yr{motion}
vim.keymap.set("n", "<leader>ya", function()
	vim.o.operatorfunc = "v:lua.require'mengo.yank'.op_yank_absolute"
	return "g@"
end, { expr = true, desc = "[Y]ank with [A]bsolute path + motion" })

vim.keymap.set("n", "<leader>yr", function()
	vim.o.operatorfunc = "v:lua.require'mengo.yank'.op_yank_relative"
	return "g@"
end, { expr = true, desc = "[Y]ank with [R]elative path + motion" })

-- Visual mode: <leader>ya, <leader>yr
vim.keymap.set("v", "<leader>ya", function()
	yank.yank_visual_with_path(yank.get_buffer_absolute(), "absolute")
end, { desc = "[Y]ank selection with [A]bsolute path" })

vim.keymap.set("v", "<leader>yr", function()
	yank.yank_visual_with_path(yank.get_buffer_cwd_relative(), "relative")
end, { desc = "[Y]ank selection with [R]elative path" })

vim.keymap.set("n", "<leader>pp", ":Telescope neovim-project discover<CR>", { desc = "Project discover" })
vim.keymap.set("n", "<leader>pph", ":Telescope neovim-project history<CR>", { desc = "Project history" })

vim.keymap.set("n", "<leader>sc", "<cmd>Scratch<cr>", { desc = "New scratch buffer" })
vim.keymap.set("n", "<leader>sco", "<cmd>ScratchOpen<cr>", { desc = "Open scratch buffer picker" })
vim.keymap.set(
	"n",
	"<leader>srf",
	":lua require('grug-far').open({ prefills = { paths = vim.fn.expand('%'), transient=true, engine='astgrep' } })<CR>",
	{ desc = "Search & replace in current file (grug-far)" }
)

-- Treesitter: incremental selection + function/class motions
-- (adapted from dmmulroy/dotfiles keymaps.lua; mini.ai already covers
-- af/if/ac/ic-style textobjects, so only the parts mini.ai doesn't do live here)
local treesitter_select = function()
	if not vim.treesitter.get_parser(0, nil, { error = false }) then
		return nil
	end
	local ok, select = pcall(require, "vim.treesitter._select")
	if ok then
		return select
	end
	return nil
end

local treesitter_select_parent = function()
	local select = treesitter_select()
	if select then
		select.select_parent(vim.v.count1)
	else
		vim.lsp.buf.selection_range(vim.v.count1)
	end
end

local treesitter_select_child = function()
	local select = treesitter_select()
	if select then
		select.select_child(vim.v.count1)
	else
		vim.lsp.buf.selection_range(-vim.v.count1)
	end
end

local treesitter_move = function(method, query, query_group)
	return function()
		require("nvim-treesitter-textobjects.move")[method](query, query_group or "textobjects")
	end
end

keymap("n", "<C-Space>", function()
	if treesitter_select() then
		vim.cmd.normal({ "van", bang = true })
	else
		vim.lsp.buf.selection_range(1)
	end
end, { desc = "Treesitter: Start incremental selection" })

keymap("x", "<C-Space>", treesitter_select_parent, { desc = "Treesitter: Expand selection" })
keymap("x", "<C-h>", treesitter_select_child, { desc = "Treesitter: Shrink selection" })

keymap({ "n", "x", "o" }, "]m", treesitter_move("goto_next_start", "@function.outer"), { desc = "Next function start" })
keymap({ "n", "x", "o" }, "]]", treesitter_move("goto_next_start", "@class.outer"), { desc = "Next class start" })
keymap({ "n", "x", "o" }, "]M", treesitter_move("goto_next_end", "@function.outer"), { desc = "Next function end" })
keymap(
	{ "n", "x", "o" },
	"[m",
	treesitter_move("goto_previous_start", "@function.outer"),
	{ desc = "Previous function start" }
)
keymap(
	{ "n", "x", "o" },
	"[[",
	treesitter_move("goto_previous_start", "@class.outer"),
	{ desc = "Previous class start" }
)
keymap(
	{ "n", "x", "o" },
	"[M",
	treesitter_move("goto_previous_end", "@function.outer"),
	{ desc = "Previous function end" }
)

-- ── Builtin command cheatsheet (reference, no maps needed) ──────────────────
-- :g/pattern/norm A;           run normal-mode keys on every matching line
-- :cdo s/foo/bar/g             edit every quickfix entry (telescope <C-q> sends to qf)
-- :cfdo s/old/new/ge | update  project-wide replace via quickfix files
-- :earlier 10m  /  :later 10m  time-travel undo by wall clock
-- g<C-a>  (visual block)       increment as sequence: 0,0,0 -> 1,2,3
-- gi                           insert mode at last insert position
-- g; / g,                      jump back/forward through change list
-- gv                           reselect last visual selection (gV = last change/yank)
-- Q                            replay last recorded macro
-- :=vim.o.ft                   lua-print anything (:= is :lua vim.print shorthand)
-- :%!jq .                      filter buffer through any shell command
-- <C-r>=  (insert mode)        expression register, e.g. <C-r>=strftime('%Y-%m-%d')
-- :put =range(1,20)            generate number lines
-- :sort u / :sort n            sort unique / numeric (works on visual range)
-- :InspectTree / :EditQuery    builtin treesitter playground
-- :restart                     restart nvim in place (0.12+)
