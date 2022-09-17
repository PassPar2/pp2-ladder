fx_version 'cerulean'
game 'gta5'

author 'PassPar2'

description 'pp2-ladder'
version '1.0.0'

shared_scripts {
  'locales/en.lua',
  'config/config.lua'
}

server_script {
  'server/server.lua'
}

client_scripts {
  'client/client.lua'
}

lua54 'yes'
