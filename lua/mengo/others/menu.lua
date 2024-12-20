vim.cmd [[
  aunmenu PopUp
  anoremenu PopUp.Inspect       <cmd>Inspect<CR>
  amenu PopUp.-1-               <NOP>
  anoremenu PopUp.Definition    <cmd>lua vim.lsp.buf.definition()<CR>
  anoremenu PopUp.References    <cmd>Telescope lsp_references<CR>
  anoremenu PopUp.Back          <C-t>
  amenu PopUp.-2-               <NOP>
  anoremenu PopUp.URL           <cmd>lua vim.fn.system({"open", vim.fn.expand("<cfile>")})<CR>
  ]]
-- [a]ll[un][menu], [a]ll[nore]map[menu]

local group = vim.api.nvim_create_augroup("nvim_popupmenu", { clear = true })

-- http://google.com
vim.api.nvim_create_autocmd("MenuPopup", {
  pattern = "*",
  group = group,
  desc = "Custom Popup Setup",
  callback = function()
    vim.cmd [[
      amenu disable PopUp.Definition
      amenu disable PopUp.References
      amenu disable PopUp.URL
    ]]
    if vim.lsp.get_clients({ bufnr = 0 })[1] then
      vim.cmd [[
        amenu enable PopUp.Definition
        amenu enable PopUp.References
      ]]
    end

    local word_under_cursor = vim.fn.expand('<cfile>')
    if word_under_cursor:match('^https?://') then
      vim.cmd [[amenu enable PopUp.URL]]
    end
  end
})
