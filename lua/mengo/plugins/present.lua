return {
  {
    dir = vim.fn.stdpath("config") .. "/lua/mengo/others/present.nvim",
    dev = true,
    config = function()
      require("present").setup()
    end,
  },
}
