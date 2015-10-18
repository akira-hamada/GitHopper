require('./functions.coffee')
require('./constants.coffee')

# 特定のクラスが付いたリンクはChromeで開く
$('.js-open-in-chrome').on 'click', (e) =>
  e.preventDefault()
  require("shell").openExternal(e.target.href)

if localStorage.getItem('only_private_repo')?
  $('#only-private-repo').prop('checked',true) if localStorage.getItem('only_private_repo') == '1'
else
  localStorage.setItem('only_private_repo', 0)

$('#only-private-repo').on 'change', ->
  if $(this).prop('checked')
    localStorage.setItem('only_private_repo', 1)
  else
    localStorage.setItem('only_private_repo', 0)

$('#owner').val(localStorage.getItem('owner')) if localStorage.getItem('owner')?
$('#owner').on 'keyup', -> localStorage.setItem('owner', $(this).val())

$('#github-access-token').val(localStorage.getItem('githubAccessToken')) if localStorage.getItem('githubAccessToken')?
$('#github-access-token').on 'keyup', -> localStorage.setItem('githubAccessToken', $(this).val())
