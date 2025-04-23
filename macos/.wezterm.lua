-- Pull in the wezterm API
local wezterm = require("wezterm")
-- This will hold the configuration.
local config = wezterm.config_builder()
-- This is where you actually apply your config choices
-- uncomment this to use color scheme
-- config.color_scheme = "Navy and Ivory (terminal.sexy)"
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 19
config.enable_tab_bar = true
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.macos_window_background_blur = 10
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

-- 添加按鍵設定
config.keys = {
    -- Option+左箭頭：跳到前一個單詞
    {
        key = "LeftArrow",
        mods = "OPT",
        action = wezterm.action.SendKey {
            key = "b",
            mods = "ALT",
        },
    },
    -- Option+右箭頭：跳到下一個單詞
    {
        key = "RightArrow",
        mods = "OPT",
        action = wezterm.action.SendKey {
            key = "f",
            mods = "ALT",
        },
    },
    
    -- Shift+Option+左箭頭：向左選擇一個單詞
    {
        key = "LeftArrow",
        mods = "SHIFT|OPT",
        action = wezterm.action.SendKey {
            key = "b", 
            mods = "ALT|SHIFT",
        },
    },
    
    -- Shift+Option+右箭頭：向右選擇一個單詞
    {
        key = "RightArrow",
        mods = "SHIFT|OPT",
        action = wezterm.action.SendKey {
            key = "f",
            mods = "ALT|SHIFT",
        },
    },
}

-- and finally, return the configuration to wezterm
return config
