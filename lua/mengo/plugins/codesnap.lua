return {
	"mistricky/codesnap.nvim",
	version = "^1",
	lazy = true,
	config = function()
		require("codesnap").setup({
			mac_window_bar = false,
			watermark = "CodeSnap.nvim",
			title = "CodeSnap.nvim",
			code_font_family = "CaskaydiaCove Nerd Font",
			watermark_font_family = "Pacifico",
			save_path = "/Users/menghongho/Downloads/Codesnap"
		})
	end
}
