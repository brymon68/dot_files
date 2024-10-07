return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "InsertEnter",
		keys = {
			{
				"<leader>ct",
				function()
					if require("copilot.client").is_disabled() then
						require("copilot.command").enable()
					else
						require("copilot.command").disable()
					end
				end,
				desc = "Toggle (Copilot)",
			},
		},
		config = function()
			require("copilot").setup({
				panel = {
					enabled = true,
					auto_refresh = true,
					keymap = {
						jump_next = "<c-j>",
						jump_prev = "<c-k>",
						accept = "<c-a>",
						refresh = "r",
						open = "<M-CR>",
					},
					layout = {
						position = "right", -- | top | left | right
						ratio = 0.4,
					},
				},
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 75,
					keymap = {
						accept = "<c-a>",
						accept_word = false,
						accept_line = false,
						next = "<c-j>",
						prev = "<c-k>",
						dismiss = "<C-e>",
					},
				},
			})
			require("copilot.command").disable()
		end,
	},
}
