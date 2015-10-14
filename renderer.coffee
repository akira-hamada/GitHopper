require('./app/functions.coffee')
require('./app/constants.coffee')
global.Clipboard = require('clipboard')

key '⌘+h, ctrl+h', toggleSidebar
key '⌘+[, ctrl+[', browserBack
key '⌘+], ctrl+]', browserForward

# 特定のクラスが付いたリンクはChromeで開く
$('.js-open-in-chrome').on 'click', (e) =>
  e.preventDefault()
  require("shell").openExternal(e.target.href)

if localStorage.getItem('githubAccessToken')? && localStorage.getItem('githubAccessToken') != ''
  afterValidateToken localStorage.getItem('githubAccessToken'),
    =>
      renderApplication()
    =>
      localStorage.removeItem('githubAccessToken')
      displayTokenInput()
else
  displayTokenInput()
