-- Adapted from dmmulroy/dotfiles: lua/dmmulroy/prelude.lua (open_link).
-- Opens the link under the cursor. Understands markdown links `[text](url)`
-- and bare URLs (including ones sitting inside parens); falls back to <cfile>.
local M = {}

function M.open_link()
	local line = vim.fn.getline(".")
	local col = vim.fn.col(".")

	local md_link_pattern = "%[.-%]%((.-)%)"
	local url_pattern = "https?://[%w%-_%.%?%.:/%+=&]+"

	local start_pos = 1
	while true do
		local md_start, md_end, url = line:find(md_link_pattern, start_pos)
		if not md_start then
			break
		end
		if col >= md_start and col <= md_end then
			vim.ui.open(url)
			return
		end
		start_pos = md_end + 1
	end

	start_pos = 1
	while true do
		local url_start, url_end = line:find(url_pattern, start_pos)
		if not url_start then
			break
		end
		if col >= url_start and col <= url_end then
			vim.ui.open(line:sub(url_start, url_end))
			return
		end
		start_pos = url_end + 1
	end

	vim.ui.open(vim.fn.expand("<cfile>"))
end

return M
