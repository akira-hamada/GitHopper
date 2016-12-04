require('./functions.coffee')

# 特定のクラスが付いたリンクはChromeで開く
$('.js-open-in-chrome').on 'click', (e) =>
  e.preventDefault()
  require('electron').shell.openExternal(e.target.href)

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

$('#after-launch').val(localStorage.getItem('after-launch')) if localStorage.getItem('after-launch')?
$('#after-launch').on 'keyup', -> localStorage.setItem('after-launch', $(this).val())

$('#append-repos').val(localStorage.getItem('append-repos')) if localStorage.getItem('append-repos')?
$('#append-repos').on 'keyup', -> localStorage.setItem('append-repos', $(this).val())

$('#remove-repos').val(localStorage.getItem('remove-repos')) if localStorage.getItem('remove-repos')?
$('#remove-repos').on 'keyup', -> localStorage.setItem('remove-repos', $(this).val())
