local set = vim.opt_local
set.shiftwidth = 2
set.tabstop = 2

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.jsx",
    callback = function()
        vim.fn.setreg('r', "diwAMath.floor(Math.random() * pa))")
        vim.fn.setreg('s', "0f\"s{`;s`}")
        vim.fn.setreg('c', "vatof>i className=\"\"i")
    end,
})
