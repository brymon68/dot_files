local colors = require("theme").colors
local wezterm = require("wezterm")

local Tab = {}

local function get_process(tab)
	local PROCESS_ICONS = {
		["nvim"] = {
			{ Foreground = { Color = colors.green } },
			{ Text = "" },
		},
		["node"] = {
			{ Foreground = { Color = colors.green } },
			{ Text = "󰋘" },
		},
		["python"] = {
			{ Foreground = { Color = colors.green } },
			{ Text = "" },
		},
		["zsh"] = {
			{ Foreground = { Color = colors.peach } },
			{ Text = "" },
		},
		["bash"] = {
			{ Foreground = { Color = colors.overlay1 } },
			{ Text = "" },
		},
		["htop"] = {
			{ Foreground = { Color = colors.yellow } },
			{ Text = "" },
		},
		["btop"] = {
			{ Foreground = { Color = colors.rosewater } },
			{ Text = "" },
		},
		["cargo"] = {
			{ Foreground = { Color = colors.peach } },
			{ Text = wezterm.nerdfonts.dev_rust },
		},
		["go"] = {
			{ Foreground = { Color = colors.sapphire } },
			{ Text = "" },
		},
		["git"] = {
			{ Foreground = { Color = colors.peach } },
			{ Text = "󰊢" },
		},
		["lua"] = {
			{ Foreground = { Color = colors.blue } },
			{ Text = "" },
		},
		["wget"] = {
			{ Foregrou = { Color = colors.yellow } },
			{ Text = "󰄠" },
		},
		["curl"] = {
			{ Foreground = { Color = colors.yellow } },
			{ Text = "" },
		},
	}

	local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")

	if PROCESS_ICONS[process_name] then
		return wezterm.format(PROCESS_ICONS[process_name])
	elseif process_name == "" then
		return wezterm.format({
			{ Foreground = { Color = colors.red } },
			{ Text = "󰌾" },
		})
	else
		return wezterm.format({
			{ Foreground = { Color = colors.blue } },
			{ Text = string.format("[%s]", process_name) },
		})
	end
end

local function get_current_working_dir(tab)
	local cwd_uri = tab.active_pane.current_working_dir

	if cwd_uri then
		local cwd = ""
		if type(cwd_uri) == "userdata" then
			cwd = cwd_uri.file_path
		else
			cwd_uri = cwd_uri:sub(8)
			local slash = cwd_uri:find("/")
			if slash then
				cwd = cwd_uri:sub(slash):gsub("%%(%x%x)", function(hex)
					return string.char(tonumber(hex, 16))
				end)
			end
		end

		if cwd == os.getenv("HOME") then
			return "~"
		end

		return string.format("%s", string.match(cwd, "[^/]+$"))
	end
end

function Tab.setup(config)
	config.use_fancy_tab_bar = true
	config.tab_max_width = 50
	config.show_new_tab_button_in_tab_bar = false
	config.hide_tab_bar_if_only_one_tab = false

	wezterm.on("format-tab-title", function(tab)
		return wezterm.format({
			{ Text = "  " },
			{ Text = string.format("%s", tab.tab_index + 1) },
			"ResetAttributes",
			{ Text = "  " },
			{ Text = get_process(tab) },
			{ Text = " " },
			{ Text = get_current_working_dir(tab) },
			{ Foreground = { Color = colors.base } },
			{ Text = " ▕" },
		})
	end)
	wezterm.on("window-resized", function(tab)
		return wezterm.format({
			{ Text = "  " },
			{ Text = string.format("%s", tab.tab_index + 1) },
			"ResetAttributes",
			{ Text = "  " },
			{ Text = get_process(tab) },
			{ Text = " " },
			{ Text = get_current_working_dir(tab) },
			{ Foreground = { Color = colors.base } },
			{ Text = " ▕" },
		})
	end)
end

return Tab
