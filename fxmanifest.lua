fx_version 'cerulean'
game 'gta5'

author 'Geliştirici'
description 'Envanter Sistemi'


server_scripts {
    '@oxmysql/lib/MySQL.lua', 
    'server.lua'
}


client_scripts {
    'client.lua'
}


ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js',
    'ui/img/*.png' 
}


capabilities {
    'unstable'
}
