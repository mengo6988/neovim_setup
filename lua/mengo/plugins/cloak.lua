return {
	"laytan/cloak.nvim",
	-- load before .env & co render so secrets never flash on screen
	event = { "BufReadPre", "BufNewFile" },
	opts = {},
}
