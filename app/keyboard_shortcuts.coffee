# --------------------------------------
# キーボードショートカット定義ファイル
# 主にkeymaster.js を使用 (https://github.com/madrobby/keymaster)
# --------------------------------------

# Inputにフォーカスしている場合もキーボードショートカットを有効にする
#   https://github.com/madrobby/keymaster#filter-key-presses
key.filter = (event) ->
  tagName = (event.target || event.srcElement).tagName
  # console.log event
  # console.log tagName
  key.setScope(/^INPUT$/.test(tagName) ? 'input' : 'other')

  return true

key '⌘+f, ctrl+f', displayPRIssueSearchBox
key '⌘+s, ctrl+s', toggleSidebar
key '⌘+o, ctrl+o', openInBrowser
key '⌘+[, ctrl+[', browserBack
key '⌘+], ctrl+]', browserForward
key '⌘+r, ctrl+r', browserReload
key '⌘+p, ctrl+p', displayPR
key '⌘+i, ctrl+i', displayIssues
key '⌘+t, ctrl+t', displayRepositoryTopPage
key '⌘+/, ctrl+/', displayKeyBoardShorCut
key '⌘+u, ctrl+u', copycurrentUrl
key 'tab', nextRepo
key 'shift+tab', prevRepo
key "⌘+1, ctrl+1", (event, handler) -> $(".repo:first-child").click()
key "⌘+9, ctrl+9", (event, handler) -> $(".repo:last-child").click()
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


key 'esc', (event, handler) ->
  if _isShortcutOnId('pr-issue-search-box')
    $(event.target).val('').addClass('hide')
    $('#black-screen').addClass('hide')
    getCurrentRepository().focus()
  else if not $('#cheatsheet').hasClass('hide')
    $('#cheatsheet').addClass('hide')
    $('#black-screen').addClass('hide')
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
