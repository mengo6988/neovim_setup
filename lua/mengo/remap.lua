local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.keymap.set

-- Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
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
keymap("n", "-", "<cmd>Oil<CR>")
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")
keymap("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>")
keymap("n", "<leader>bd", "<cmd>:Bdelete<CR>")
keymap("n", "<leader>bo", ":%bd|e#|bd#<CR>", { noremap = true, silent = true, desc = "Close other buffers" })
keymap("n", "<leader>ibl", "<cmd>:IBLToggle<CR>", { desc = "Indent Blank Line toggle" })
keymap("n", "<leader>f", "<cmd>:Format<CR>", { desc = "Format" })
keymap("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "Open parent directory" })
keymap("n", "<leader>db", "<CMD>DBUIToggle<CR>", { desc = "[D][B]UI Toggle" })
keymap("n", "<leader>np", "<CMD>NoNeckPain<CR>", { desc = "No[N]eck[Pain]" })
keymap("n", "<leader>nl", "<CMD>Noice last<CR>", { desc = "[N]oice [L]ast" })
keymap("n", "<leader>nd", "<CMD>Noice dismiss<CR>", { desc = "[N]oice [D]ismiss" })
keymap("n", "<leader>nh", "<CMD>Noice history<CR>", { desc = "[N]oice [H]istory" })
keymap("n", "<leader>on", "<CMD>Nvumi<CR>", { desc = "[O]pen [N]vumi" })

keymap("n", "<leader>so", ":source %<CR>")
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
end)
-- Testing here, Idk what to put yet, but maybe can have a complicated one to use, suggestion (send highlighted command into terminal)
keymap("n", "<leader>example", function()
	if vim.g.last_term_job_id then
		vim.fn.chansend(vim.g.last_term_job_id, { 'echo "hello"\r\n' })
	else
		vim.notify("No terminal job — open one with <leader>st first", vim.log.levels.WARN)
	end
end)

-- Save quit etc
keymap("n", "<leader>w", ":w!<CR>", opts)
keymap("n", "<leader>wf", "<cmd>FormatEnable<CR><cmd>w<cr><cmd>FormatDisable<CR>", opts)
keymap("n", "<leader>x", ":x!<CR>", opts)
keymap("n", "<leader>q", ":q!<CR>", opts)
keymap("n", "<leader>wq", ":wq!<CR>", opts)

-- Better window navigation
keymap("n", "<leader>h", "<C-w>h", opts)
keymap("n", "<leader>j", "<C-w>j", opts)
keymap("n", "<leader>k", "<C-w>k", opts)
keymap("n", "<leader>l", "<C-w>l", opts)

-- keymap("n", "]c", "<cmd>cnext<CR>", { desc = "[C]uikfix Next" })
-- keymap("n", "[c", "<cmd>cprev<CR>", { desc = "[C]uikfix Prev" })

-- Quickfix
keymap("n", "]q", "<cmd>cnext<CR>zz", { desc = "Quickfix next" })
keymap("n", "[q", "<cmd>cprev<CR>zz", { desc = "Quickfix prev" })
keymap("n", "<leader>qo", "<cmd>copen<CR>", { desc = "[Q]uickfix [O]pen" })
keymap("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "[Q]uickfix [C]lose" })

-- Swap window layout
keymap("n", "<leader>wh", "<C-w>t<C-w>H", { noremap = true, silent = true, desc = "Swap to vertical layout" })
keymap("n", "<leader>wk", "<C-w>t<C-w>K", { noremap = true, silent = true, desc = "Swap to horizontal layout" })

-- Vertical Splits
keymap("n", "<leader>v", ":vsplit<CR>", opts)
keymap("n", "<leader>s", ":split<CR>", opts)
keymap("n", "<leader>,", ":only<CR>", { noremap = true, silent = true, desc = "Focus" })
keymap("n", "<leader>c", ":close<CR>", { noremap = true, silent = true, desc = "Close" })

-- Special Remaps
keymap("n", "gV", "`[v`]", { noremap = true, desc = "Select last changed or yanked text" })
keymap("n", "yc", "yy<cmd>normal gcc<CR>p", { desc = "Copy paste and comment the line copied" })
keymap("n", "<C-s><C-s>", ":.!sh<cr>", { noremap = true, desc = "Send current line to sh and REPLACE with the output" })
keymap("i", "jk", "<Esc>", opts)

-- Better navigation
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Better File Navigation
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "<C-f>", "<C-f>zz", opts)
keymap("n", "<C-b>", "<C-b>zz", opts)
keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)
keymap("n", "*", "*zz", opts)
keymap("n", "#", "#zz", opts)
keymap("n", "G", "Gzz", opts)

-- Resize with arrows
keymap("n", "<C-S-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-S-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-S-Left>", ":vertical resize +2<CR>", opts)
keymap("n", "<C-S-Right>", ":vertical resize -2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<M-j>", ":m .+1<CR>==", opts)
keymap("n", "<M-k>", ":m .-2<CR>==", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv^", opts)
keymap("v", ">", ">gv^", opts)
keymap("v", "<leader>y", '"+y', opts)

-- Move text up and down
keymap("v", "<M-k>", ":m '<-2<CR>gv=gv", opts)
keymap("v", "<M-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":m '>+1<CR>gv=gv", opts)
keymap("x", "K", ":m '<-2<CR>gv=gv", opts)
keymap("x", "<M-j>", ":m '>+1<CR>gv=gv", opts)
keymap("x", "<M-k>", ":m '<-2<CR>gv=gv", opts)

-- LSP attach for lsp commands

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
	callback = function(event)
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

		-- Rename the variable under your cursor.
		--  Most Language Servers support renaming across files, etc.
		map("<leader>vrn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("<leader>vh", vim.lsp.buf.signature_help, "Signature [Help]")

		-- Execute a code action, usually your cursor needs to be on top of an error
		-- or a suggestion from your LSP for this to activate.
		map("<leader>vca", vim.lsp.buf.code_action, "[C]ode [A]ction")

		-- Opens a popup that displays documentation about the word under your cursor
		--  See `:help K` for why this keymap.
		map("K", vim.lsp.buf.hover, "Hover Documentation")

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
			vim.diagnostic.jump({ count = -1 })
		end, "Previous [D]iagnostic")
		map("]d", function()
			vim.diagnostic.jump({ count = 1 })
		end, "Next [D]iagnostic")

		-- Inlay hints
		if client and client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
		end
		map("<leader>ih", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
		end, "Toggle [I]nlay [H]ints")

		-- Attach navic for winbar breadcrumbs
		if client and client.server_capabilities.documentSymbolProvider then
			local ok, navic = pcall(require, "nvim-navic")
			if ok then
				navic.attach(client, event.buf)
			end
		end
	end,
})

-- Refactor nvim remaps
-- vim.keymap.set("x", "<leader>re", ":Refactor extract ")
-- vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ")
--
-- vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ")
--
-- vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var")
--
-- vim.keymap.set("n", "<leader>rI", ":Refactor inline_func")
--
-- vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
-- vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")

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

vim.keymap.set("n", "<leader>pp", ":Telescope neovim-project discover<CR>")
vim.keymap.set("n", "<leader>pph", ":Telescope neovim-project history<CR>")
-- vim.keymap.set("n", "<leader>g", ":Git<CR>")
-- vim.keymap.set("n", "<leader>gc", ":Git commit<CR>")
-- vim.keymap.set("n", "<leader>gp", ":Git push<CR>")
-- vim.keymap.set("n", "<leader>gu", ":Git pull<CR>")
-- vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit!<CR>")
-- vim.keymap.set("n", "<leader>gdh", ":diffget //2<CR>")
-- vim.keymap.set("n", "<leader>gdl", ":diffget //3<CR>")

vim.keymap.set("n", "<leader>sc", "<cmd>Scratch<cr>")
vim.keymap.set("n", "<leader>sco", "<cmd>ScratchOpen<cr>")
vim.keymap.set(
	"n",
	"<leader>srf",
	":lua require('grug-far').open({ prefills = { paths = vim.fn.expand('%'), transient=true, engine='astgrep' } })<CR>"
)
