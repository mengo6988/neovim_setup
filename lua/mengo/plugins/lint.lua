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
			-- no python entry: the ruff LSP is auto-enabled by mason-lspconfig
			-- (the ruff package is installed for ruff_format) and already reports
			-- F-rules here; adding ruff to nvim-lint double-reports every finding.
		}

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
			callback = function()
				local linters = lint.linters_by_ft[vim.bo.filetype]
				if not linters then
					return
				end
				-- eslint_d errors out on projects without an eslint config; skip those.
				-- Scoped to eslint filetypes so non-JS linters still run.
				if vim.tbl_contains(linters, "eslint_d") then
					local root = vim.fs.root(0, {
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
					if not root or vim.fn.executable("eslint_d") ~= 1 then
						return
					end
					-- run from the config root so eslint_d resolves the project-local
					-- eslint instead of falling back to its bundled version
					lint.linters.eslint_d.cwd = root
				end
				lint.try_lint()
			end,
		})
	end,
}
