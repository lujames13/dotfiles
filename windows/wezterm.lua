local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end


config.font = wezterm.font("JetBrainsMonoNL Nerd Font Mono")
config.font_size = 19
config.enable_tab_bar = ture
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.default_prog = { 'wsl.exe', '~' }
-- my coolnight colorscheme:
config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}

config.keys = {
	-- This will create a new split and run your default program inside it
	{
	  key = 'V',
	  mods = 'CTRL|SHIFT|ALT',
	  action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
	},
	{
		key = 'H',
		mods = 'CTRL|SHIFT|ALT',
		action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
	},
  
  }

-- 只需要一個 return，放在最後
return config