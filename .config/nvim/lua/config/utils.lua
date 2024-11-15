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

return M
