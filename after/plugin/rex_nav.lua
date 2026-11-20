-- <C-h/j/k/l> across Rex panes and nvim splits. Rex's init.lua passes the key
-- through while nvim is in front, and at an edge split this hands focus back
-- with init.lua's pane_focus action, which also crosses into a docked side
-- float such as the markdown preview. Sorts after herdr_nav.lua, so it wins inside Rex. Does
-- nothing outside Rex, or under tmux inside Rex, where TmuxNavigate* stays.
if not vim.env.REX_SESSION or vim.env.TMUX then
	return
end

for key, dir in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
	vim.keymap.set("n", "<C-" .. key .. ">", function()
		local win = vim.api.nvim_get_current_win()
		vim.cmd.wincmd(key)
		if vim.api.nvim_get_current_win() == win then
			vim.system({ "rex", "do", "-s", vim.env.REX_SESSION, "pane_focus", "direction=" .. dir })
		end
	end, { desc = "Rex/window: navigate " .. dir })
end
