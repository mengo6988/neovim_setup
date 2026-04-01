return {
	"catgoose/nvim-colorizer.lua",
	config = function()
		require("colorizer").setup({
			filetypes = { "css", "javascript", "html" },
			user_default_options = {
				mode = "background",
			},
		})
	end,
}
