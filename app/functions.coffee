# GitHubの認証処理を実行する
global.githubAuth = ->
  Github = require('github-api')

  github = new Github(
    token: GITHUB_ACCESS_TOKEN
    auth: "oauth"
  )
  user = github.getUser()

  return user

# プライベートレポジトリを取得する
global.setPrivateRepositories = (repositories) ->
  this.repos = repositories.filter (repo) -> repo.owner.login == 'ShareWis' && repo.private

# アクティブなレポジトリを初期化する
global.initializeActiveRepository = ->
  this.activeRepo = null

# レポジトリ一覧を表示する
global.renderReposList = ->
  for repo in this.repos
    $('#repositories').append("<li class='list-item repo' data-url='#{repo.html_url}' data-repo='#{repo.name}' data-id='#{repo.id}'><span class='octicon octicon-repo text-muted'></span>#{repo.name}</li>")
    $('#webview-wrapper').append("<webview id='#{repo.id}' class='repository-viewer hide' src='#{repo.html_url}' autosize='on'></webview>")

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

    $('.repository-viewer').addClass('hide')
    $("##{$(this).data('id')}").removeClass('hide')
    this.activeRepo = $(this).data('id')

# サイドバーを開閉する
global.toggleSidebar = ->
  $('.side-menu').toggleClass('collapsed')
  $('.main-view').toggleClass('full')
