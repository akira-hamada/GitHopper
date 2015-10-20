require('./functions.coffee')
require('./constants.coffee')
require('./keyboard_shortcuts.coffee')
ipc = require('ipc')

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

ipc.on 'onShortcutTriggered', (arg) ->
  console.log(arg)
