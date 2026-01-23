local set = vim.opt_local
set.shiftwidth = 2
set.tabstop = 2
vim.keymap.set("n", "<leader>cc", function()
  local line = vim.api.nvim_get_current_line()

  if line:match("%[ %]") then
    line = line:gsub("%[ %]", "[x]", 1)
  elseif line:match("%[x%]") then
    line = line:gsub("%[x%]", "[ ]", 1)
  else
    return
  end

  vim.api.nvim_set_current_line(line)
end, { desc = "Toggle markdown checkbox" })

vim.keymap.set("x", "<leader>cc", function()
  local start = vim.fn.line("'<")
  local finish = vim.fn.line("'>")

  for i = start, finish do
    local line = vim.fn.getline(i)

    if line:match("%[ %]") then
      line = line:gsub("%[ %]", "[x]", 1)
    elseif line:match("%[x%]") then
      line = line:gsub("%[x%]", "[ ]", 1)
    end

    vim.fn.setline(i, line)
  end
end, { desc = "Toggle markdown checkboxes (visual)" })

vim.keymap.set("n", "<leader>oc", "o- [ ] ", {desc = "Insert checkbox in new row"})
vim.keymap.set("n", "<leader>ic", "I- [ ] <Esc>", {desc = "Insert checkbox in new row"})
