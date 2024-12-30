---@diagnostic disable

local present_dir = vim.fn.expand('$HOME/.config/nvim/lua/mengo/others/present.nvim/lua')
package.path = present_dir .. "/?.lua;" .. package.path
local parse = require("present")._parse_slides
local eq = assert.are.same
describe("present.parse_slides", function()
  it("should parse an empty file", function()
    eq({
      slides = {
        {
          title = '',
          body = {},
          blocks = {},
        }
      }
    }, parse {})
  end)

  it("should parse a file with 1 slides", function()
    eq({
      slides = {
        {
          title = '# This is the first slide',
          body = { "This is the body" },
          blocks = {},
        }
      }
    }, parse {
      "# This is the first slide",
      "This is the body"
    })
  end)

  it("should parse a file with 1 slide and a block", function()
    local results = parse {
      "# This is the first slide",
      "This is the body",
      "```lua",
      "print('hi')",
      "```",
    }
    print(vim.inspect(results))
    -- Should only have 1 slide
    eq(1, #results.slides)
    local slide = results.slides[1]

    eq('# This is the first slide', slide.title)
    eq({

      "This is the body",
      "```lua",
      "print('hi')",
      "```",
    }, slide.body)
    eq({
      language = "lua",
      body = "print('hi')"
    }, slide.blocks[1])
  end)
end)
