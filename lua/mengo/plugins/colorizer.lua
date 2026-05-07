return {
	"catgoose/nvim-colorizer.lua",
	ft = { "css", "scss", "html", "javascript", "javascriptreact", "typescript", "typescriptreact" },
	config = function()
		require("colorizer").setup({
			filetypes = {
				"css",
				"scss",
				"html",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			},
			options = {
				parsers = {
					css = true,
					tailwind = { enable = true, lsp = true },
				},
				display = {
					mode = "foreground",
					disable_document_color = true,
				},
			},
		})
	end,
}
