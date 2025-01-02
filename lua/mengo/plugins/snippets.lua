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
        return "// %s"                      -- Default to C-style comments
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
      "jsonc",
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
        i(0)
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

    -- #####################################################################
    --                         all the filetypes
    -- #####################################################################
    ls.add_snippets("all", {
      s({
        trig = "workflow",
        name = "Add this -> lamw25wmal",
        desc = "Add this -> lamw25wmal",
      }, {
        t("lamw25wmal"),
      }),

      s({
        trig = "lam",
        name = "Add this -> lamw25wmal",
        desc = "Add this -> lamw25wmal",
      }, {
        t("lamw25wmal"),
      }),

      s({
        trig = "mw25",
        name = "Add this -> lamw25wmal",
        desc = "Add this -> lamw25wmal",
      }, {
        t("lamw25wmal"),
      }),

      s("todo", {
        f(function()
          return get_comment_string()
        end),
        t("TODO: "),
        i(1, "todo text")
      }),

      s("note", {
        f(function()
          return get_comment_string()
        end),
        t("NOTE: "),
        i(1, "note text")
      }),

      s("warn", {
        f(function()
          return get_comment_string()
        end),
        t("WARN: "),
        i(1, "warn text")
      }),

      s("bug", {
        f(function()
          return get_comment_string()
        end),
        t("BUG: "),
        i(1, "bug text")
      }),
    })
  end
}
