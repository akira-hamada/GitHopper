require('./functions.coffee')
require('./constants.coffee')
global.Clipboard = require('clipboard')

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

$('#owner').on 'change', -> localStorage.setItem('owner', $(this).val())
