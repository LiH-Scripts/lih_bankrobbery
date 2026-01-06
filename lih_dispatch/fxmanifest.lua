fx_version 'cerulean'
games {'gta5'}
lua54 'yes'

author 'Justin'
description 'LiH Dispatch System'
version '1.0.0'

ui_page 'html/index.html'

client_script {
  'client/**',
}

server_script {
  "server/**",
}

shared_script {
  '@es_extended/imports.lua',
  '@ox_lib/init.lua',
  'shared/config.lua',
}

files {
  'html/**',
  'locales/*.json',
}

ox_lib 'locale' -- v3.8.0 or above