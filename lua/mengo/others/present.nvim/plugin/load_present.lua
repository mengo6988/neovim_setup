if vim.g.loaded_present == 1 then return end
vim.g.loaded_present = 1

-- vim.notify("loading present")
vim.api.nvim_create_user_command("PresentStart", function()
  require("present").start_presentation()
end, {})
-- vim.api.nvim_create_user_command("PresentStart", function ()
--   require("present").start_presentation()
-- end, {})
