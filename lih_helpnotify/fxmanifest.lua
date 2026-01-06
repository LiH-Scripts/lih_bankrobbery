shared_script "@nso_truckerjob/anvil.lua"
fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Justin'
description 'LiH-Helpnotify'

client_scripts { 
    'client/*.lua',
}

ui_page 'html/index.html'

files {
    'html/**/'
}

exports {
    'showHelpNotification',
	'hideHelpNotification'
}
dependency '/assetpacks'

server_scripts {
	--[[server.lua]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            'server/utils/.runtime.js',
}
