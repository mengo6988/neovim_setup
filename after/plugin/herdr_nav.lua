-- Seamless <C-h/j/k/l> across herdr panes and nvim splits (vim-herdr-navigation).
-- Sourced after lazy.nvim registers keys, so it wins over vim-tmux-navigator's
-- mappings; inside tmux it hands back to TmuxNavigate*, so tmux keeps working.
-- No-op when the herdr plugin isn't installed.
local nav = vim.fn.glob(
	vim.fn.expand("~/.config/herdr/plugins/github/vim-herdr-navigation-*/editor/nvim.lua"),
	false,
	true
)
if #nav > 0 then
	dofile(nav[1])
end
