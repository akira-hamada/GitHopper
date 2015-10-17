require('./functions.coffee')
require('./constants.coffee')

key '⌘+h, ctrl+h', toggleSidebar
key '⌘+[, ctrl+[', browserBack
key '⌘+], ctrl+]', browserForward
key '⌘+r, ctrl+r', browserReload
key '⌘+p, ctrl+p', displayPR
key '⌘+i, ctrl+i', displayIssues
key 'tab', nextRepo
key 'shift+tab', prevRepo

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
