fx_version 'cerulean'
games { 'gta5' }

author 'Noneya Business'
description ''
version '1.0.0'

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
    '@oxmysql/lib/MySQL.lua',
}

shared_scripts {
    'config.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/*.css',
	'html/*.js',
	'html/images/*.png',
    'html/sounds/*.ogg',
}