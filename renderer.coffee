require('./app/functions.coffee')
require('./app/constants.coffee')

loginUser = githubAuth()

loginUser.repos (err, repos) ->
  setPrivateRepositories(repos)
  initializeActiveRepository()

  renderReposList()
  fadeOutLaunchLogo()

  $('.list-item').on 'click', ->
    activateSelectedRepo(this)

key '⌘+h, ctrl+h', toggleSidebar
key '⌘+[, ctrl+[', browserBack
key '⌘+], ctrl+]', browserForward
