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
					-- lsp = true: tailwindcss-language-server is installed and
					-- auto-enabled, so it supplies colors alongside regex matching
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
