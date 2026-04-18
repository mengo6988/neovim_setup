return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	build = "make install_jsregexp",
	dependencies = { "rafamadriz/friendly-snippets" },
	config = function()
		local ls = require("luasnip")
		require("luasnip.loaders.from_vscode").lazy_load()

		local s = ls.s
		local t = ls.text_node
		local i = ls.insert_node
		local f = ls.function_node
		local function clipboard()
			return vim.fn.getreg("+")
		end

		-- Custom snippets
		-- the "all" after ls.add_snippets("all" is the filetype, you can know a
		-- file filetype with :set ft
		-- Custom snippets

		-- #####################################################################
		--                            Markdown
		-- #####################################################################

		-- Helper function to create code block snippets
		local function create_code_block_snippet(lang)
			return s({
				trig = lang,
				name = "Codeblock",
				desc = lang .. " codeblock",
			}, {
				t({ "```" .. lang, "" }),
				i(1),
				t({ "", "```" }),
			})
		end

		-- Helper function to get comment string based on filetype
		local function get_comment_string()
			local comment_string = vim.bo.commentstring
			if comment_string == "" then
				return "// %s" -- Default to C-style comments
			end
			return comment_string:gsub("%%s", "") -- Remove the %s placeholder
		end

		-- Define languages for code blocks
		local languages = {
			"prisma",
			"txt",
			"lua",
			"sql",
			"go",
			"regex",
			"bash",
			"markdown",
			"markdown_inline",
			"yaml",
			"json",
			"cpp",
			"java",
			"javascript",
			"typescript",
			"python",
			"dockerfile",
			"html",
			"css",
			"rust",
			"php",
		}

		-- Generate snippets for all languages
		local markdown_snippets = {}

		for _, lang in ipairs(languages) do
			table.insert(markdown_snippets, create_code_block_snippet(lang))
		end

		table.insert(
			markdown_snippets,
			s({
				trig = "markdownlint",
				name = "Add markdownlint disable and restore headings",
				desc = "Add markdownlint disable and restore headings",
			}, {
				t({
					" ",
					"<!-- markdownlint-disable -->",
					" ",
					"> ",
				}),
				i(1),
				t({
					" ",
					" ",
					"<!-- markdownlint-restore -->",
				}),
			})
		)

		table.insert(
			markdown_snippets,
			s({
				trig = "prettierignore",
				name = "Add prettier ignore start and end headings",
				desc = "Add prettier ignore start and end headings",
			}, {
				t({
					" ",
					"<!-- prettier-ignore-start -->",
					" ",
					"> ",
				}),
				i(1),
				t({
					" ",
					" ",
					"<!-- prettier-ignore-end -->",
				}),
			})
		)

		table.insert(
			markdown_snippets,
			s({
				trig = "linkt",
				name = 'Add this -> [](){:target="_blank"}',
				desc = 'Add this -> [](){:target="_blank"}',
			}, {
				t("["),
				i(1),
				t("]("),
				i(2),
				t('){:target="_blank"}'),
			})
		)

		table.insert(
			markdown_snippets,
			s({
				trig = "todo",
				name = "Add TODO: item",
				desc = "Add TODO: item",
			}, {
				t("<!-- TODO: "),
				i(1),
				t(" -->"),
			})
		)

		table.insert(
			markdown_snippets,
			s({
				trig = "todolist",
				name = "Add TODO-list: item",
				desc = "Add TODO-list: item",
			}, {
				t({ "## Todo-list", "", "" }), -- Using table for multiline text
				t("- [ ] "),
				i(1),
				t({ "", "" }), -- New lines after todo item
				i(0),
			})
		)
		-- Paste clipboard contents in link section, move cursor to ()
		table.insert(
			markdown_snippets,
			s({
				trig = "linkclip",
				name = "Paste clipboard as .md link",
				desc = "Paste clipboard as .md link",
			}, {
				t("["),
				i(1),
				t("]("),
				f(clipboard, {}),
				t(")"),
			})
		)

		ls.add_snippets("markdown", markdown_snippets)
		ls.add_snippets("json", {
			s("prettier", {
				t({
					"{",
					'  "printWidth": ',
				}),
				i(1, "80"),
				t({
					",",
					'  "tabWidth": ',
				}),
				i(2, "2"),
				t({
					",",
					'  "useTabs": ',
				}),
				i(3, "false"),
				t({
					",",
					'  "semi": ',
				}),
				i(4, "true"),
				t({
					",",
					'  "singleQuote": ',
				}),
				i(5, "true"),
				t({
					",",
					'  "trailingComma": ',
				}),
				i(6, '"all"'),
				t({
					",",
					'  "bracketSpacing": ',
				}),
				i(7, "true"),
				t({
					",",
					'  "arrowParens": ',
				}),
				i(8, '"always"'),
				t({
					",",
					'  "proseWrap": ',
				}),
				i(9, '"preserve"'),
				t({
					",",
					'  "endOfLine": ',
				}),
				i(10, '"auto"'),
				t({
					",",
					'  "embeddedLanguageFormatting": ',
				}),
				i(11, '"auto"'),
				t({
					"",
					"}",
				}),
			}),
		})

		-- #####################################################################
		--                         all the filetypes
		-- #####################################################################
		ls.add_snippets("all", {
			s("todo", {
				f(function()
					return get_comment_string()
				end),
				t("TODO: "),
				i(1, "todo text"),
			}),

			s("note", {
				f(function()
					return get_comment_string()
				end),
				t("NOTE: "),
				i(1, "note text"),
			}),

			s("warn", {
				f(function()
					return get_comment_string()
				end),
				t("WARN: "),
				i(1, "warn text"),
			}),

			s("bug", {
				f(function()
					return get_comment_string()
				end),
				t("BUG: "),
				i(1, "bug text"),
			}),

			s("test", {
				f(function()
					return get_comment_string()
				end),
				t("TEST: "),
				i(1, "test text"),
			}),
		})
		-- Additional "all" snippets
		ls.add_snippets("all", {
			s("fixme", {
				f(function()
					return get_comment_string()
				end),
				t("FIXME: "),
				i(1, "fixme text"),
			}),

			s("hack", {
				f(function()
					return get_comment_string()
				end),
				t("HACK: "),
				i(1, "hack text"),
			}),

			s({
				trig = "date",
				name = "Insert today's date",
				desc = "Insert today's date (YYYY-MM-DD)",
			}, {
				f(function()
					return os.date("%Y-%m-%d")
				end),
			}),

			s({
				trig = "time",
				name = "Insert current datetime",
				desc = "Insert current datetime (YYYY-MM-DD HH:MM:SS)",
			}, {
				f(function()
					return os.date("%Y-%m-%d %H:%M:%S")
				end),
			}),
		})

		-- #####################################################################
		--                      TypeScript / JavaScript
		-- #####################################################################
		local js_ts_snippets = {
			s({
				trig = "cls",
				name = "console.log string",
				desc = 'console.log("")',
			}, {
				t('console.log("'),
				i(1),
				t('");'),
			}),

			s({
				trig = "clf",
				name = "console.log with file context",
				desc = "console.log with filename and label",
			}, {
				t('console.log("['),
				f(function()
					return vim.fn.expand("%:t")
				end),
				t('] '),
				i(1, "label"),
				t(':", '),
				i(2, "value"),
				t(");"),
			}),

			s({
				trig = "afn",
				name = "Arrow function",
				desc = "const name = (params) => {}",
			}, {
				t("const "),
				i(1, "name"),
				t(" = ("),
				i(2),
				t({ ") => {", "\t" }),
				i(3),
				t({ "", "};" }),
			}),

			s({
				trig = "usee",
				name = "useEffect",
				desc = "useEffect with cleanup",
			}, {
				t({ "useEffect(() => {", "\t" }),
				i(1),
				t({ "", "\treturn () => {", "\t\t" }),
				i(2),
				t({ "", "\t};", "" }),
				t("}, ["),
				i(3),
				t("]);"),
			}),

			s({
				trig = "usse",
				name = "useState",
				desc = "const [state, setState] = useState()",
			}, {
				t("const ["),
				i(1, "state"),
				t(", set"),
				f(function(args)
					local name = args[1][1]
					return name:sub(1, 1):upper() .. name:sub(2)
				end, { 1 }),
				t("] = useState("),
				i(2),
				t(");"),
			}),

			s({
				trig = "tryc",
				name = "try/catch/finally",
				desc = "try/catch/finally block",
			}, {
				t({ "try {", "\t" }),
				i(1),
				t({ "", "} catch (error) {", "\t" }),
				i(2),
				t({ "", "} finally {", "\t" }),
				i(3),
				t({ "", "}" }),
			}),

			s({
				trig = "imp",
				name = "import",
				desc = 'import { } from "module"',
			}, {
				t("import { "),
				i(2),
				t(' } from "'),
				i(1, "module"),
				t('";'),
			}),

			s({
				trig = "expd",
				name = "export default",
				desc = "export default",
			}, {
				t("export default "),
				i(1),
				t(";"),
			}),

			s({
				trig = "fetcha",
				name = "Async fetch",
				desc = "Async fetch with error handling",
			}, {
				t({ "try {", '\tconst response = await fetch("' }),
				i(1, "url"),
				t({ '");', "\tif (!response.ok) {", '\t\tthrow new Error(`HTTP error! status: ${response.status}`);', "\t}", "\tconst data = await response.json();", "\t" }),
				i(2),
				t({ "", "} catch (error) {", "\tconsole.error(error);", "}" }),
			}),

			s({
				trig = "tsdis",
				name = "@ts-expect-error",
				desc = "// @ts-expect-error comment",
			}, {
				t("// @ts-expect-error "),
				i(1, "reason"),
			}),
		}

		for _, ft in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
			ls.add_snippets(ft, js_ts_snippets)
		end

		-- #####################################################################
		--                              Python
		-- #####################################################################
		ls.add_snippets("python", {
			s({
				trig = "ifmain",
				name = "if __name__ == __main__",
				desc = 'if __name__ == "__main__": block',
			}, {
				t({ 'if __name__ == "__main__":', "\t" }),
				i(1, "main()"),
			}),

			s({
				trig = "pdb",
				name = "breakpoint",
				desc = "Insert breakpoint()",
			}, {
				t("breakpoint()"),
			}),

			s({
				trig = "dclass",
				name = "dataclass",
				desc = "@dataclass with fields",
			}, {
				t({ "@dataclass", "class " }),
				i(1, "ClassName"),
				t({ ":", "\t" }),
				i(2, "field"),
				t(": "),
				i(3, "str"),
			}),

			s({
				trig = "typd",
				name = "TypedDict",
				desc = "TypedDict definition",
			}, {
				t("class "),
				i(1, "Name"),
				t({ "(TypedDict):", "\t" }),
				i(2, "key"),
				t(": "),
				i(3, "str"),
			}),

			s({
				trig = "ctxm",
				name = "Context manager",
				desc = "with statement",
			}, {
				t("with "),
				i(1, "open()"),
				t(" as "),
				i(2, "f"),
				t({ ":", "\t" }),
				i(3),
			}),

			s({
				trig = "logd",
				name = "logger.debug",
				desc = "logger.debug with f-string",
			}, {
				t('logger.debug(f"'),
				i(1, "message"),
				t(' {'),
				i(2, "var"),
				t('=}")'),
			}),
		})

		-- #####################################################################
		--                                Go
		-- #####################################################################
		ls.add_snippets("go", {
			s({
				trig = "iferr",
				name = "if err != nil return",
				desc = "if err != nil { return err }",
			}, {
				t({ "if err != nil {", "\treturn " }),
				i(1, "err"),
				t({ "", "}" }),
			}),

			s({
				trig = "ife",
				name = "if err != nil wrapped",
				desc = "if err != nil with fmt.Errorf wrap",
			}, {
				t({ "if err != nil {", '\treturn fmt.Errorf("' }),
				i(1, "failed to %s"),
				t('": %w", '),
				i(2),
				t({ "err)", "}" }),
			}),

			s({
				trig = "httph",
				name = "HTTP handler",
				desc = "HTTP handler function",
			}, {
				t("func "),
				i(1, "handler"),
				t({ "(w http.ResponseWriter, r *http.Request) {", "\t" }),
				i(2),
				t({ "", "}" }),
			}),

			s({
				trig = "testf",
				name = "Test function",
				desc = "func TestXxx(t *testing.T)",
			}, {
				t("func Test"),
				i(1, "Name"),
				t({ "(t *testing.T) {", "\t" }),
				i(2),
				t({ "", "}" }),
			}),

			s({
				trig = "tabltest",
				name = "Table-driven test",
				desc = "Table-driven test skeleton",
			}, {
				t({ "tests := []struct {", "\tname string", "\t" }),
				i(1, "input string"),
				t({ "", "\t" }),
				i(2, "want  string"),
				t({ "", "}{", "\t{" }),
				t({ "", '\t\tname: "' }),
				i(3, "test case"),
				t({ '",', "\t}," }),
				t({ "", "}", "", "for _, tt := range tests {", '\tt.Run(tt.name, func(t *testing.T) {', "\t\t" }),
				i(4),
				t({ "", "\t})", "}" }),
			}),

			s({
				trig = "ctx",
				name = "context parameter",
				desc = "ctx context.Context",
			}, {
				t("ctx context.Context"),
			}),
		})

		-- #####################################################################
		--                               Rust
		-- #####################################################################
		ls.add_snippets("rust", {
			s({
				trig = "testm",
				name = "Test module",
				desc = "#[cfg(test)] mod tests",
			}, {
				t({ "#[cfg(test)]", "mod tests {", "\tuse super::*;", "", "\t#[test]", "\tfn " }),
				i(1, "test_name"),
				t({ "() {", "\t\t" }),
				i(2),
				t({ "", "\t}", "}" }),
			}),

			s({
				trig = "der",
				name = "#[derive]",
				desc = "#[derive(...)]",
			}, {
				t("#[derive("),
				i(1, "Debug, Clone"),
				t(")]"),
			}),

			s({
				trig = "implst",
				name = "impl block",
				desc = "impl for struct",
			}, {
				t("impl "),
				i(1, "StructName"),
				t({ " {", "\t" }),
				i(2),
				t({ "", "}" }),
			}),

			s({
				trig = "matchr",
				name = "match Result",
				desc = "match with Ok/Err arms",
			}, {
				t("match "),
				i(1, "value"),
				t({ " {", "\tOk(" }),
				i(2, "val"),
				t({ ") => {", "\t\t" }),
				i(3),
				t({ "", "\t}", "\tErr(" }),
				i(4, "e"),
				t({ ") => {", "\t\t" }),
				i(5),
				t({ "", "\t}", "}" }),
			}),

			s({
				trig = "printd",
				name = "dbg! macro",
				desc = "dbg!(value)",
			}, {
				t("dbg!("),
				i(1),
				t(");"),
			}),
		})

		-- #####################################################################
		--                               Lua
		-- #####################################################################
		ls.add_snippets("lua", {
			s({
				trig = "plug",
				name = "Lazy.nvim plugin spec",
				desc = "Plugin spec skeleton for lazy.nvim",
			}, {
				t({ "return {", '\t"' }),
				i(1, "author/plugin"),
				t({ '",', "\tconfig = function()", "\t\t" }),
				i(2),
				t({ "", "\tend,", "}" }),
			}),

			s({
				trig = "auc",
				name = "nvim_create_autocmd",
				desc = "vim.api.nvim_create_autocmd",
			}, {
				t('vim.api.nvim_create_autocmd("'),
				i(1, "BufEnter"),
				t({ '", {', "\tpattern = " }),
				i(2, '"*"'),
				t({ ",", "\tcallback = function()", "\t\t" }),
				i(3),
				t({ "", "\tend,", "})" }),
			}),

			s({
				trig = "map",
				name = "vim.keymap.set",
				desc = "vim.keymap.set with desc",
			}, {
				t('vim.keymap.set("'),
				i(1, "n"),
				t('", "'),
				i(2, "<leader>"),
				t('", '),
				i(3),
				t(', { desc = "'),
				i(4, "description"),
				t('" })'),
			}),

			s({
				trig = "augroup",
				name = "Autocmd group",
				desc = "Create autocmd group with clear",
			}, {
				t('local '),
				i(1, "group"),
				t(' = vim.api.nvim_create_augroup("'),
				i(2, "GroupName"),
				t({ '", { clear = true })', "" }),
				t('vim.api.nvim_create_autocmd("'),
				i(3, "BufEnter"),
				t({ '", {', "\tgroup = " }),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				t({ ",", "\tcallback = function()", "\t\t" }),
				i(4),
				t({ "", "\tend,", "})" }),
			}),
		})

		-- #####################################################################
		--                             Solidity
		-- #####################################################################
		ls.add_snippets("solidity", {
			s({
				trig = "cont",
				name = "Contract",
				desc = "Contract skeleton",
			}, {
				t({ "// SPDX-License-Identifier: " }),
				i(1, "MIT"),
				t({ "", "pragma solidity ^" }),
				i(2, "0.8.20"),
				t({ ";", "", "contract " }),
				i(3, "MyContract"),
				t({ " {", "\t" }),
				i(4),
				t({ "", "}" }),
			}),

			s({
				trig = "func",
				name = "Function",
				desc = "Function with visibility",
			}, {
				t("function "),
				i(1, "name"),
				t("("),
				i(2),
				t(") "),
				i(3, "public"),
				t(" "),
				i(4, "returns ()"),
				t({ " {", "\t" }),
				i(5),
				t({ "", "}" }),
			}),

			s({
				trig = "event",
				name = "Event + emit",
				desc = "Event declaration and emit",
			}, {
				t("event "),
				i(1, "Transfer"),
				t("("),
				i(2, "address indexed from, address indexed to, uint256 value"),
				t({ ");", "" }),
				t("emit "),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				t("("),
				i(3),
				t(");"),
			}),

			s({
				trig = "mod",
				name = "Modifier",
				desc = "Modifier skeleton",
			}, {
				t("modifier "),
				i(1, "onlyOwner"),
				t({ "() {", '\trequire(' }),
				i(2, "msg.sender == owner"),
				t(', "'),
				i(3, "Not authorized"),
				t({ '");', "\t_;", "}" }),
			}),

			s({
				trig = "req",
				name = "require",
				desc = "require(condition, message)",
			}, {
				t("require("),
				i(1, "condition"),
				t(', "'),
				i(2, "Error message"),
				t('");'),
			}),
		})

		-- Add a gitignore snippet for all filetypes
		ls.add_snippets("all", {
			s({
				trig = "gitignore",
				name = "GitIgnore Template",
				desc = "Create a comprehensive .gitignore template",
			}, {
				t({
					"# Python / Django",
					"__pycache__/",
					"*.py[cod]",
					"*$py.class",
					"*.so",
					".Python",
					"build/",
					"develop-eggs/",
					"dist/",
					"downloads/",
					"eggs/",
					".eggs/",
					"lib/",
					"lib64/",
					"parts/",
					"sdist/",
					"var/",
					"wheels/",
					"*.egg-info/",
					".installed.cfg",
					"*.egg",
					".env",
					".venv",
					"env/",
					"venv/",
					"ENV/",
					"env.bak/",
					"venv.bak/",
					".python-version",
					"*.log",
					"local_settings.py",
					"db.sqlite3",
					"db.sqlite3-journal",
					"media/",
					"staticfiles/",
					"",
					"# Next.js / Nest.js (Node.js)",
					".next/",
					"out/",
					".vercel",
					"node_modules/",
					".pnp/",
					".pnp.js",
					"npm-debug.log*",
					"yarn-debug.log*",
					"yarn-error.log*",
					".pnpm-debug.log*",
					".yarn/cache",
					".yarn/unplugged",
					".yarn/build-state.yml",
					".yarn/install-state.gz",
					"coverage/",
					".nyc_output",
					"",
					"# Docker",
					".dockerignore",
					"docker-compose.override.yml",
					"",
					"# Solidity / Foundry",
					"cache/",
					"artifacts/",
					"forge-cache/",
					"out/",
					"broadcast/",
					"lcov.info",
					"coverage/",
					".gas-snapshot",
					".env.local",
					"typechain/",
					"typechain-types/",
					"deployments/",
					".openzeppelin/",
					"",
					"# Editor/IDE",
					".idea/",
					".vscode/",
					"*.swp",
					"*.swo",
					".DS_Store",
					".env.local",
					".env.development.local",
					".env.test.local",
					".env.production.local",
					"",
					"# Misc",
					"*.pem",
					".eslintcache",
					".npm",
					"logs",
					".DS_Store",
					"**/.DS_Store",
				}),
			}),
		})

		-- #####################################################################
		--                      Dev-services env blocks
		-- #####################################################################
		-- Pairs: local (host→localhost) and container (app→service DNS on `mengo` network).
		-- Triggers ending in `c` = container mode.
		ls.add_snippets("all", {
			s({ trig = "envpg", name = "Postgres env (local)", desc = "DATABASE_URL via localhost" }, {
				t({
					"# Prisma / Postgres — local mode",
					'DATABASE_URL="postgresql://postgres:postgres@localhost:5432/dev?schema=public"',
					'DIRECT_URL="postgresql://postgres:postgres@localhost:5432/dev?schema=public"',
					"POSTGRES_USER=postgres",
					"POSTGRES_PASSWORD=postgres",
					"POSTGRES_DB=dev",
					"POSTGRES_HOST=localhost",
					"POSTGRES_PORT=5432",
				}),
			}),
			s({ trig = "envpgc", name = "Postgres env (container)", desc = "DATABASE_URL via dev-postgres DNS" }, {
				t({
					"# Prisma / Postgres — container mode (network: mengo)",
					'DATABASE_URL="postgresql://postgres:postgres@dev-postgres:5432/dev?schema=public"',
					'DIRECT_URL="postgresql://postgres:postgres@dev-postgres:5432/dev?schema=public"',
					"POSTGRES_USER=postgres",
					"POSTGRES_PASSWORD=postgres",
					"POSTGRES_DB=dev",
					"POSTGRES_HOST=dev-postgres",
					"POSTGRES_PORT=5432",
				}),
			}),
			s({ trig = "envredis", name = "Redis env (local)" }, {
				t({
					"# Redis — local mode",
					'REDIS_URL="redis://localhost:6379"',
					"REDIS_HOST=localhost",
					"REDIS_PORT=6379",
				}),
			}),
			s({ trig = "envredisc", name = "Redis env (container)" }, {
				t({
					"# Redis — container mode (network: mengo)",
					'REDIS_URL="redis://dev-redis:6379"',
					"REDIS_HOST=dev-redis",
					"REDIS_PORT=6379",
				}),
			}),
			s({ trig = "envmail", name = "Mailpit env (local)" }, {
				t({
					"# Mailpit — local mode (UI http://localhost:8025)",
					"SMTP_HOST=localhost",
					"SMTP_PORT=1025",
					"SMTP_USER=",
					"SMTP_PASS=",
					"SMTP_SECURE=false",
					'MAIL_FROM="dev@localhost"',
				}),
			}),
			s({ trig = "envmailc", name = "Mailpit env (container)" }, {
				t({
					"# Mailpit — container mode (network: mengo)",
					"SMTP_HOST=dev-mailpit",
					"SMTP_PORT=1025",
					"SMTP_USER=",
					"SMTP_PASS=",
					"SMTP_SECURE=false",
					'MAIL_FROM="dev@localhost"',
				}),
			}),
			s({ trig = "envs3", name = "MinIO env (local)" }, {
				t({
					"# MinIO — local mode (console http://localhost:9001)",
					'S3_ENDPOINT="http://localhost:9000"',
					"S3_REGION=us-east-1",
					"S3_ACCESS_KEY_ID=minioadmin",
					"S3_SECRET_ACCESS_KEY=minioadmin",
					"S3_BUCKET=dev",
					"S3_FORCE_PATH_STYLE=true",
				}),
			}),
			s({ trig = "envs3c", name = "MinIO env (container)" }, {
				t({
					"# MinIO — container mode (network: mengo)",
					'S3_ENDPOINT="http://dev-minio:9000"',
					"S3_REGION=us-east-1",
					"S3_ACCESS_KEY_ID=minioadmin",
					"S3_SECRET_ACCESS_KEY=minioadmin",
					"S3_BUCKET=dev",
					"S3_FORCE_PATH_STYLE=true",
				}),
			}),
		})
	end,
}
