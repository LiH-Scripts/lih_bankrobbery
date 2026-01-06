shared_script "@nso_truckerjob/anvil.lua"
fx_version 'cerulean'
games {'gta5'}
lua54 'yes'

author 'Justin'
description 'LiH - Customsounds'
version '1.0.0'

client_scripts {
	"config.lua",
	"client/main.lua",
	"client/events.lua",

	"client/exports/info.lua",
	"client/exports/play.lua",
	"client/exports/manipulation.lua",
	"client/exports/events.lua",
	"client/effects/main.lua",

	"client/emulator/interact_sound/client.lua",
}

ui_page "html/index.html"

files {
	"html/index.html",

	"html/scripts/listener.js",
	"html/scripts/SoundPlayer.js",
	"html/scripts/functions.js",

	"html/sounds/*.ogg",
	"html/sounds/*.mp3",
	"html/sounds/*.wav",
}