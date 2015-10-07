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
    privateRepos = repos.filter (repo) -> repo.owner.login == 'ShareWis' && repo.private
    for repo in privateRepos
      $('#repositories').append("<li class='list-item repo' data-url='#{repo.html_url}' data-repo='#{repo.name}'><span class='octicon octicon-repo text-muted'></span>#{repo.name}</li>")

    $('#launch-logo').fadeOut 'fast', ->
      $(this).remove()
      $('#repositories').removeClass('collapsed')

    $('.list-item').on 'click', ->
      $('.list-item').removeClass('active')
      $(this).addClass('active')
      $("#repository-view").attr('src', $(this).data('url')).removeClass('hide')

# サイドバーを開閉する
global.toggleSidebar = ->
  $('.side-menu').toggleClass('collapsed')
  $('.main-view').toggleClass('full')
