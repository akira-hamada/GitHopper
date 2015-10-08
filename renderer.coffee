require('./app/functions.coffee')
require('./app/constants.coffee')

loginUser = githubAuth()

loginUser.repos (err, repos) ->
  setPrivateRepositories(repos)

  renderReposList()
  fadeOutLaunchLogo()
  onClickListEvent()


key '⌘+h, ctrl+h', toggleSidebar
