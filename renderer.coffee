require('./app/functions.coffee')
require('./app/constants.coffee')
global.Clipboard = require('clipboard')

key '⌘+h, ctrl+h', toggleSidebar
key '⌘+[, ctrl+[', browserBack
key '⌘+], ctrl+]', browserForward

if localStorage.getItem('githubAccessToken')? && localStorage.getItem('githubAccessToken') != ''
  afterValidateToken localStorage.getItem('githubAccessToken'),
    =>
      renderApplication()
    =>
      localStorage.removeItem('githubAccessToken')
      displayTokenInput()
else
  displayTokenInput()
