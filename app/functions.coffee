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
global.renderReposList = (repos) ->
  privateRepos = repos.filter (repo) -> repo.owner.login == 'ShareWis' && repo.private
  for repo in privateRepos
    $('#repositories').append("<li class='list-item repo' data-url='#{repo.html_url}' data-repo='#{repo.name}'><span class='octicon octicon-repo text-muted'></span>#{repo.name}</li>")

# スプラッシュロゴを非表示にする
global.fadeOutLaunchLogo = ->
  $('#launch-logo').fadeOut 'fast', ->
    $(this).remove()
    $('#repositories').removeClass('collapsed')

# リストクリック時の処理
global.onClickListEvent = ->
  $('.list-item').on 'click', ->
    $('.list-item').removeClass('active')
    $(this).addClass('active')
    $("#repository-view").attr('src', $(this).data('url')).removeClass('hide')

# サイドバーを開閉する
global.toggleSidebar = ->
  $('.side-menu').toggleClass('collapsed')
  $('.main-view').toggleClass('full')
