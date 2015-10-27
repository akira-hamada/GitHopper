# --------------------------------------
# キーボードショートカット定義ファイル
# 主にkeymaster.js を使用 (https://github.com/madrobby/keymaster)
# --------------------------------------
ipc = require('ipc')
key = require('keymaster')

ipc.on 'onShortcutTriggered', (arg) ->
  switch arg
    when 'Cmd+f' then displayPRIssueSearchBox()
    when 'Cmd+shift+f' then displayTextSearchBox()
    when 'Cmd+i' then displayIssues()
    when 'Cmd+shift+i' then displayClosedIssues()
    when 'Cmd+j' then nextRepo()
    when 'Cmd+k' then prevRepo()
    when 'Cmd+o' then openInBrowser()
    when 'Cmd+p' then displayPR()
    when 'Cmd+shift+p' then displayClosedPR()
    when 'Cmd+r' then browserReload()
    when 'Cmd+s' then toggleSidebar()
    when 'Cmd+t' then displayRepositoryTopPage()
    when 'Cmd+u' then copycurrentUrl()
    when 'Cmd+/' then displayKeyBoardShorCut()
    when 'Cmd+left' then browserBack()
    when 'Cmd+right' then browserForward()
    when 'Cmd+1' then $(".repo:first-child").click()
    when 'Cmd+9' then $(".repo:last-child").click()

# Inputにフォーカスしている場合もキーボードショートカットを有効にする
#   https://github.com/madrobby/keymaster#filter-key-presses
key.filter = (event) ->
  tagName = (event.target || event.srcElement).tagName
  # console.log event
  # console.log tagName
  key.setScope(/^INPUT$/.test(tagName) ? 'input' : 'other')

  return true

key '⌘+b', searchText
key '⌘+[, ctrl+[, ⌘+h, ctrl+h', browserBack
key '⌘+], ctrl+], ⌘+l, ctrl+l', browserForward
key 'tab', nextRepo
key 'shift+tab', prevRepo
for n in [2..8]
  key "⌘+#{n}, ctrl+#{n}", (event, handler) -> $(".repo:nth-child(#{handler.shortcut.split('+')[1]})").click()

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
      searchText($(event.target).val())

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
    $('#text-search-wrapper').addClass('hide')
    getCurrentRepository().focus()

$('#pr-issue-search-box').on 'blur', ->
  $(this).val('').addClass('hide')
  $('#black-screen').addClass('hide')

# 指定したIDで発生したショートカットならtrueを返す
_isShortcutOnId = (id) ->
  this.event.target.id == id

# 入力欄が空ならtrue
_isEmptyInput = ->
  $(this.event.target).val() == ''
