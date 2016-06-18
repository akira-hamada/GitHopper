# --------------------------------------
# キーボードショートカット定義ファイル
# 主にkeymaster.js を使用 (https://github.com/madrobby/keymaster)
# --------------------------------------
ipc = require('electron').ipcRenderer
key = require('keymaster')

ipc.on 'onShortcutTriggered', (event, arg) ->
  switch arg
    when 'g' then displayPRIssueSearchBox()
    when 'f' then displayTextSearchBox()
    when 'i' then displayIssues()
    when 'shift+i' then displayClosedIssues()
    when 'j' then nextRepo()
    when 'k' then prevRepo()
    when 'o' then openInBrowser()
    when 'p' then displayPR()
    when 'shift+p' then displayClosedPR()
    when 'r' then browserReload()
    when 's' then toggleSidebar()
    when 't' then displayRepositoryTopPage()
    when 'u' then copycurrentUrl()
    when '/' then displayKeyBoardShorCut()
    when 'left' then browserBack()
    when 'right' then browserForward()
    when '1' then $(".repo:first-child").click()
    when '9' then $(".repo:last-child").click()

# Inputにフォーカスしている場合もキーボードショートカットを有効にする
#   https://github.com/madrobby/keymaster#filter-key-presses
key.filter = (event) ->
  tagName = (event.target || event.srcElement).tagName
  # console.log event
  # console.log tagName
  key.setScope(/^INPUT$/.test(tagName) ? 'input' : 'other')

  return true

if process.platform == 'darwin'
  mdfKey = '⌘'
else
  mdfKey = 'ctrl'

key "#{mdfKey}+b", searchText
key "#{mdfKey}+[, #{mdfKey}+h", browserBack
key "#{mdfKey}+], #{mdfKey}+l", browserForward
key 'tab', nextRepo
key 'shift+tab', prevRepo
for n in [2..8]
  key "#{mdfKey}+#{n}", (event, handler) -> $(".repo:nth-child(#{handler.shortcut.split('+')[1]})").click()

key 'return', (event, handler) ->
  if _isShortcutOnId('pr-issue-search-box')
    unless _isEmptyInput()
      digits = $(event.target).val().match(/^\d+$/)
      if digits?
        getCurrentRepository().attr('src', "#{getCurrentRepositoryUrl()}/pull/#{digits[0]}").focus()
        $(event.target).val('').addClass('hide')
        $('#black-screen').addClass('hide')
      else
        console.log "invalid format"
  else if _isShortcutOnId('token-input')
    unless _isEmptyInput()
      afterValidateToken $(event.target).val(),
        =>
          $('.input-err-msg').addClass('hide')
          localStorage.setItem('githubAccessToken', $(event.target).val())
          $(event.target).val('')
          renderApplication()
        =>
          $('.input-err-msg').removeClass('hide')
  else if _isShortcutOnId('text-search-input')
    unless _isEmptyInput()
      searchText($(event.target).val(), false)

key 'shift+return', (event, handler) ->
  if _isShortcutOnId('text-search-input') && (not _isEmptyInput())
    searchText($(event.target).val(), true)

key 'esc', (event, handler) ->
  if _isShortcutOnId('pr-issue-search-box')
    $(event.target).val('').addClass('hide')
    $('#black-screen').addClass('hide')
    getCurrentRepository().focus()
  else if not $('#cheatsheet').hasClass('hide')
    $('#cheatsheet').addClass('hide')
    $('#black-screen').addClass('hide')
    getCurrentRepository().focus()
  else if _isShortcutOnId('text-search-input')
    hideTextSearchBox()

$('#pr-issue-search-box').on 'blur', ->
  $(this).val('').addClass('hide')
  $('#black-screen').addClass('hide')

# 指定したIDで発生したショートカットならtrueを返す
_isShortcutOnId = (id) ->
  this.event.target.id == id

# 入力欄が空ならtrue
_isEmptyInput = ->
  $(this.event.target).val() == ''
