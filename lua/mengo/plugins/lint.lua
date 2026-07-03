return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
		}

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
			callback = function()
				if not lint.linters_by_ft[vim.bo.filetype] then
					return
				end
				-- eslint_d errors out on projects without an eslint config; skip those
				local has_eslint_config = vim.fs.root(0, {
					"eslint.config.js",
					"eslint.config.mjs",
					"eslint.config.cjs",
					"eslint.config.ts",
					".eslintrc",
					".eslintrc.js",
					".eslintrc.cjs",
					".eslintrc.json",
					".eslintrc.yaml",
					".eslintrc.yml",
				})
				if has_eslint_config and vim.fn.executable("eslint_d") == 1 then
					-- run from the config root so eslint_d resolves the project-local
					-- eslint instead of falling back to its bundled version
					lint.linters.eslint_d.cwd = has_eslint_config
					lint.try_lint()
				end
			end,
		})
	end,
}
