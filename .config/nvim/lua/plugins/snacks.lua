return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		explorer = {
			enabled = true,
		},
		quickfile = { enabled = true },
		picker = {
			sources = {
				explorer = {
					layout = {
						layout = {
							position = "right",
						},
					},
				},
			},
		},
	},
	keys = {
		{
			"<leader>fg",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>fs",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>fh",
			function()
				Snacks.picker.help()
			end,
			desc = "Help Pages",
		},
		{
			"<leader>fk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Keymaps",
		},
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions()
			end,
			desc = "Go to definition",
		},
		{
			"gD",
			function()
				Snacks.picker.lsp_declarations()
			end,
			desc = "Go to definition",
		},
		{
			"gi",
			function()
				Snacks.picker.lsp_implementations()
			end,
			desc = "Go to implementation",
		},
		{
			"gr",
			function()
				Snacks.picker.lsp_references()
			end,
			desc = "Go to references",
		},
		{
			"gI",
			function()
				Snacks.picker.lsp_incoming_calls()
			end,
			desc = "Incoming calls",
		},
		{
			"go",
			function()
				Snacks.picker.lsp_type_definitions()
			end,
			desc = "Go to type definition",
		},
		{
			"<leader>ca",
			function()
				Snacks.picker.lsp_code_actions()
			end,
			desc = "Code actions",
		},
		{
			"<leader>cR",
			function()
				Snacks.rename.rename_file()
			end,
			desc = "Rename File",
		},
		{
			"<leader>e",
			function()
				Snacks.explorer({
					git_status = true,
					hidden = true,
					layout = {
						position = "right",
					},
					win = {
						list = {
							keys = {
								["S-CR"] = "explorer_up",
							},
						},
					},
					auto_close = true,
				})
			end,
			desc = "File Explorer",
		},
		{
			"<leader>ff",
			function()
				require("config.utils").snacks_git_or_file()
			end,
			desc = "Find files",
		},
	},
}
