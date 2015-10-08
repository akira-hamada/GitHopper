require('./app/functions.coffee')
require('./app/constants.coffee')

loginUser = githubAuth()

loginUser.repos (err, repos) =>
  renderReposList(repos)
  fadeOutLaunchLogo()
  onClickListEvent()


key '⌘+h, ctrl+h', toggleSidebar
