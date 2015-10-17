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
key '⌘+[, ctrl+[', browserBack
key '⌘+], ctrl+]', browserForward
key '⌘+r, ctrl+r', browserReload
key '⌘+p, ctrl+p', displayPR
key '⌘+i, ctrl+i', displayIssues
key '⌘+t, ctrl+t', displayRepositoryTopPage
key 'tab', nextRepo
key 'shift+tab', prevRepo
key "⌘+1, ctrl+1", (event, handler) -> $(".repo:first-child").click()
key "⌘+9, ctrl+9", (event, handler) -> $(".repo:last-child").click()
for n in [2..8]
  key "⌘+#{n}, ctrl+#{n}", (event, handler) -> $(".repo:nth-child(#{handler.shortcut.split('+')[1]})").click()

key 'return', (event, handler) ->
  # PR/Issue検索ボックスの場合
  if event.target.id == 'pr-issue-search-box'
    if $(event.target).val() != ''
      digits = $(event.target).val().match(/^\d+$/)
      if digits?
        getCurrentRepository().attr('src', "#{getCurrentRepositoryUrl()}/pull/#{digits[0]}")
        $(event.target).val('').addClass('hide')
        $('#search-black-screen').addClass('hide')
      else
        console.log "invalid format"

  # GitHubトークン入力欄
  else if event.target.id == 'token-input'
    if $(event.target).val() != ''
      afterValidateToken $(event.target).val(),
        =>
          $('.input-err-msg').addClass('hide')
          localStorage.setItem('githubAccessToken', $(event.target).val())
          $(event.target).val('')
          renderApplication()
        =>
          $('.input-err-msg').removeClass('hide')


key 'esc', (event, handler) ->
  # PR/Issue検索ボックスの場合
  if event.target.id = 'pr-issue-search-box'
    $(event.target).val('').addClass('hide')
    $('#search-black-screen').addClass('hide')

$('#pr-issue-search-box').on 'blur', ->
  $(this).val('').addClass('hide')
  $('#search-black-screen').addClass('hide')
