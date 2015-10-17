# Inputにフォーカスしている場合もキーボードショートカットを有効にする
#   https://github.com/madrobby/keymaster#filter-key-presses
key.filter = (event) ->
  tagName = (event.target || event.srcElement).tagName
  # console.log event
  # console.log tagName
  key.setScope(/^INPUT$/.test(tagName) ? 'input' : 'other')

  return true

key '⌘+f, ctrl+f', displayPRIssueSearchBox

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
