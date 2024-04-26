local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.keymap.set


-- Remap space as leader key
keymap("", "( Space )", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

--  Plugin related
keymap("n", "<leader>pv", vim.cmd.Ex)
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")
keymap("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>")
keymap("n", "<leader>bd", "<cmd>:Bdelete<CR>")
keymap("n", "<leader>ibl", "<cmd>:IBLToggle<CR>", { desc = "Indent Blank Line toggle" })
keymap("n", "<leader>f", "<cmd>:Format<CR>", { desc = "Format" })
keymap("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- Save quit etc
keymap("n", "<leader>w", ":w!<CR>", opts)
keymap("n", "<leader>x", ":x!<CR>", opts)
keymap("n", "<leader>q", ":q!<CR>", opts)
keymap("n", "<leader>wq", ":wq!<CR>", opts)

-- Better window navigation
keymap("n", "<leader>h", "<C-w>h", opts)
keymap("n", "<leader>j", "<C-w>j", opts)
keymap("n", "<leader>k", "<C-w>k", opts)
keymap("n", "<leader>l", "<C-w>l", opts)

-- Vertical Splits
keymap("n", "<leader>v", ":vsplit<CR>", opts)
keymap("n", "<leader>s", ":split<CR>", opts)
keymap("n", "<leader>o", ":only<CR>", opts, { desc = "Focus" })
keymap("n", "<leader>c", ":close<CR>", opts, { desc = "Close" })


-- Better File Navigation
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)
keymap("n", "*", "*zz", opts)
keymap("n", "#", "#zz", opts)


-- Resize with arrows
keymap("n", "<C-S-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-S-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-S-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-S-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "∆", ":m .+1<CR>==", opts)
keymap("n", "˚", ":m .-2<CR>==", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv^", opts)
keymap("v", ">", ">gv^", opts)
keymap("v", "<leader>y", "\"+y", opts)

-- Move text up and down
keymap("v", "˚", ":m '<-2<CR>gv=gv", opts)
keymap("v", "∆", ":m '>+1<CR>gv=gv", opts)
keymap("v", "p", '"_dP', opts)


-- Visual Block --
-- Move text up and down
keymap("x", "J", ":m '>+1<CR>gv=gv", opts)
keymap("x", "K", ":m '<-2<CR>gv=gv", opts)
keymap("x", "∆", ":m '>+1<CR>gv=gv", opts)
keymap("x", "˚", ":m '<-2<CR>gv=gv", opts)


-- LSP attach for lsp commands

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
	callback = function(ev)
		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts, { desc = "Go Declaration" })
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts, { desc = "Go Definition" })
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts, { desc = "Hover" })
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<leader>vh', vim.lsp.buf.signature_help, opts, { desc = "signature_help" })
		vim.keymap.set('n', '<leader>vwa', vim.lsp.buf.add_workspace_folder, opts, { desc = "add workspace folder" })
		vim.keymap.set('n', '<leader>vwr', vim.lsp.buf.remove_workspace_folder, opts, { desc = "rm workspace folder" })
		vim.keymap.set('n', '<leader>vwl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set('n', '<leader>vD', vim.lsp.buf.type_definition, opts, { desc = "type definition" })
		vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts, { desc = "workspace symbol" })
		vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end, opts)
		vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, opts)
		vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action, opts, { desc = "code action" })
		-- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts, { desc = "references" })
		vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts, { desc = "references" })
		-- vim.keymap.set('n', 'gI', require('telescope.builtin').lsp_implementations, opts, '[G]oto [I]mplementation')
		-- vim.keymap.set('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
	end
})
