require('./functions.coffee')
require('./constants.coffee')

key '⌘+s, ctrl+s', toggleSidebar
key '⌘+[, ctrl+[', browserBack
key '⌘+], ctrl+]', browserForward
key '⌘+r, ctrl+r', browserReload
key '⌘+p, ctrl+p', displayPR
key '⌘+i, ctrl+i', displayIssues
key 'tab', nextRepo
key 'shift+tab', prevRepo
key "⌘+1, ctrl+1", (event, handler) -> $(".repo:first-child").click()
key "⌘+9, ctrl+9", (event, handler) -> $(".repo:last-child").click()
for n in [2..8]
  key "⌘+#{n}, ctrl+#{n}", (event, handler) -> $(".repo:nth-child(#{handler.shortcut.split('+')[1]})").click()

key '⌘+f, ctrl+f', displayPRIssueSearchBox
key '⌘+t, ctrl+t', displayRepositoryTopPage

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
