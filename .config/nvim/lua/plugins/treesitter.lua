return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		if not vim.env.DOTFILES_BOOTSTRAP then
			require("nvim-treesitter").install(require("config.treesitter-languages"))
		end

		-- main branch doesn't auto-enable highlighting; start it per buffer
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(ev)
				local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
				if not lang then
					return
				end
				-- language.add returns false (not an error) when no parser is
				-- installed -- e.g. plugin UI buffers like snacks pickers.
				local ok, added = pcall(vim.treesitter.language.add, lang)
				if ok and added then
					vim.treesitter.start(ev.buf, lang)
				end
			end,
		})
	end,
}
