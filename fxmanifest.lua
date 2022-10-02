fx_version 'cerulean'
game 'gta5'

author 'MaDHouSe'
description 'A useable item script for crutches!'
version '1.0.0'

shared_scripts {
	'@qb-core/shared/locale.lua',
	'locales/nl.lua', -- change en to your language
	'config.lua',
}

client_scripts {	
	"client/main.lua"
}

server_scripts {	
	"server/main.lua"
}

dependencies {
    'qb-core',
}