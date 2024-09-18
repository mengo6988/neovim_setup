return {
	"kevinhwang91/nvim-ufo",
	dependencies = "kevinhwang91/promise-async",
	config = function()
		-- Option 3: treesitter as a main provider instead
		-- Only depend on `nvim-treesitter/queries/filetype/folds.scm`,
		-- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
		require('ufo').setup({
			provider_selector = function(bufnr, filetype, buftype)
				return { 'treesitter', 'indent' }
			end
		})
	end
}
