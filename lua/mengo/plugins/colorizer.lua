return {
	"catgoose/nvim-colorizer.lua",
	ft = { "css", "javascript", "html", "scss", "typescriptreact", "javascriptreact" },
	config = function()
		require("colorizer").setup({
			filetypes = { "css", "javascript", "html" },
			user_default_options = {
				mode = "background",
			},
		})
	end,
}
