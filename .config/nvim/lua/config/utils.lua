local M = {}

function M.get_hlgroup(name, fallback)
	if vim.fn.hlexists(name) == 1 then
		local group = vim.api.nvim_get_hl(0, { name = name })

		local hl = {
			fg = group.fg == nil and "NONE" or M.parse_hex(group.fg),
			bg = group.bg == nil and "NONE" or M.parse_hex(group.bg),
		}

		return hl
	end
	return fallback or {}
end

function M.parse_hex(int_color)
	return string.format("#%x", int_color)
end

function M.get_dir()
	local handle = io.popen("echo $PWD")
	if handle ~= nil then
		local dir = handle:read("*a")
		handle:close()

		return dir:gsub("\n", "") .. "/"
	end

	return ""
end

M.snacks_git_or_file = function()
	local path = vim.fn.expand("%:p:h")
	local git_dir = vim.fn.finddir(".git", path .. ";")
	if #git_dir > 0 then
		require("snacks").picker.git_files({
			finder = "git_files",
			untracked = true,
		})
	else
		require("snacks").picker.files()
	end
end

M.copyFilePathAndLineNumber = function(visual)
	local current_file = vim.fn.expand("%:p")
	local line_ref
	if visual then
		local start_line = vim.fn.line("'<")
		local end_line = vim.fn.line("'>")
		line_ref = string.format("L%s-L%s", start_line, end_line)
	else
		line_ref = "L" .. vim.fn.line(".")
	end
	local is_git_repo = vim.fn.system("git rev-parse --is-inside-work-tree"):match("true")

	if is_git_repo then
		local current_repo = vim.fn.systemlist("git remote get-url origin")[1]
		local current_branch = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]

		-- Convert Git URL to GitHub web URL format
		current_repo = current_repo:gsub("git@([^:]+):", "https://%1/")
		current_repo = current_repo:gsub("%.git$", "")

		-- Remove leading system path to repository root
		local repo_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
		if repo_root then
			current_file = current_file:sub(#repo_root + 2)
		end

		local url = string.format("%s/blob/%s/%s#%s", current_repo, current_branch, current_file, line_ref)
		vim.fn.setreg("+", url)
		print("Copied to clipboard: " .. url)
	else
		-- If not in a Git directory, copy the full file path
		vim.fn.setreg("+", current_file .. "#" .. line_ref)
		print("Copied full path to clipboard: " .. current_file .. "#" .. line_ref)
	end
end

M.show_and_copy_diagnostic = function()
	local line = vim.fn.line(".") - 1
	local diagnostics = vim.diagnostic.get(0, { lnum = line })
	vim.diagnostic.open_float()
	if #diagnostics > 0 then
		local msgs = {}
		for _, d in ipairs(diagnostics) do
			table.insert(msgs, d.message)
		end
		vim.fn.setreg("+", table.concat(msgs, "\n"))
	end
end

return M
