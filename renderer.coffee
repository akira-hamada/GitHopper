require('./app/functions.coffee')
require('./app/constants.coffee')

loginUser = githubAuth()
renderReposList(loginUser)
