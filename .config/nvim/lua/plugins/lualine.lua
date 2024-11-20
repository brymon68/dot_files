return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "meuter/lualine-so-fancy.nvim" },
	config = function()
		local lualine = require("lualine")

		-- configure lualine with modified theme
		lualine.setup({
			sections = {
				lualine_a = {
					{ "fancy_mode", width = 3 },
				},
				lualine_b = {
					{ "filename" },
					{ "fancy_branch" },
					{ "fancy_diff" },
				},
				lualine_c = {
					{
						"fancy_diagnostics",
						sources = { "nvim_lsp" },
						symbols = { error = " ", warn = " ", info = " " },
					},
					{ "fancy_searchcount" },
				},
				lualine_x = {
					"fancy_filetype",
				},
				lualine_y = {
					"fancy_lsp_servers",
				},
			},
		})
	end,
}
