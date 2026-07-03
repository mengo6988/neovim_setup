return {
	"mistricky/codesnap.nvim",
	version = "^1",
	-- bare `lazy = true` had no trigger; commands didn't exist until manually required
	cmd = { "CodeSnap", "CodeSnapSave", "CodeSnapHighlight", "CodeSnapSaveHighlight" },
	config = function()
		require("codesnap").setup({
			mac_window_bar = false,
			watermark = "CodeSnap.nvim",
			title = "CodeSnap.nvim",
			code_font_family = "CaskaydiaCove Nerd Font",
			watermark_font_family = "Pacifico",
			save_path = vim.fn.expand("~/Downloads/Codesnap"),
		})
	end,
}
