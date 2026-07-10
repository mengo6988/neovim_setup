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
					-- lsp = false: no tailwindcss language server installed, so lsp mode
					-- never produced colors; regex matching works without it
					tailwind = { enable = true, lsp = false },
				},
				display = {
					mode = "foreground",
					disable_document_color = true,
				},
			},
		})
	end,
}
