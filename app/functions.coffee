# GitHubの認証処理を実行する
global.githubAuth = ->
  Github = require('github-api')

  github = new Github(
    token: GITHUB_ACCESS_TOKEN
    auth: "oauth"
  )
  user = github.getUser()

  return user

# レポジトリ一覧を表示する
global.renderReposList = (user) ->
  user.repos (err, repos) =>
    sharewisRepos = repos.filter (repo) -> repo.owner.login == 'ShareWis'
    for repo in sharewisRepos
      $('#repositories').append("<li class='list-item repo'>#{repo.name}</li>")
