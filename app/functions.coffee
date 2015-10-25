# トークン認証後の処理
global.afterValidateToken = (token, successCallback, failureCallback) ->
  user = githubAuth(token)

  user.notifications (err) ->
    if err == null
      console.log 'GitHub Valid Token!! :)'
      successCallback()
    else
      console.log 'GitHub Invalid Token ;('
      failureCallback()

# GitHubの認証処理を実行する
global.githubAuth = (token) ->
  Github = require('github-api')

  github = new Github(
    token: token
    auth: "oauth"
  )
  user = github.getUser()

  return user if user?

# レポジトリを設定によってフィルタリングする
global.filterRepositoryByPreference = (repositories) ->
  this.repos = repositories.filter (repo) ->
    if localStorage.getItem('only_private_repo') == '1'
      if localStorage.getItem('owner')? && localStorage.getItem('owner') != ''
        isMatchedRepo = repo.owner.login == localStorage.getItem('owner') && repo.private
      else
        isMatchedRepo = repo.private
    else
      if localStorage.getItem('owner')? && localStorage.getItem('owner') != ''
        isMatchedRepo = repo.owner.login == localStorage.getItem('owner')
      else
        isMatchedRepo = true

    isMatchedRepo

# アクティブなレポジトリを初期化する
global.initializeActiveRepository = ->
  this.activeRepo = null

# レポジトリ一覧を表示する
global.renderReposList = ->
  $('#webview-wrapper').append("<webview id='trending-repositories' class='repository-viewer invisible' src='https://github.com/trending' autosize='on'></webview>")

  for repo in this.repos
    $('#repositories').append("<li class='list-item repo' data-url='#{repo.html_url}' data-repo='#{repo.name}' data-id='#{repo.id}'><span class='octicon octicon-repo text-muted'></span>#{repo.name}</li>")
    $('#webview-wrapper').append("<webview id='#{repo.id}' class='repository-viewer hide' src='#{repo.html_url}' autosize='on'></webview>")

  $('#sidebar').nanoScroller
    contentClass: 'scroll-content'
    paneClass: 'scroll-pane'

  $('webview').on 'did-start-loading', -> $('title').text('Loading...')
  $('webview').on 'did-stop-loading', -> $('title').text($(this)[0].getTitle())

# スプラッシュロゴを非表示にする
global.fadeOutLaunchLogo = ->
  $('#launch-logo').fadeOut 'normal', ->
    $(this).remove()
    $('#sidebar').removeClass('hide')
    $('#trending-repositories').removeClass('invisible').focus()
    $('body').css('background-color', 'white')

# 選択されたレポジトリを表示する
global.activateSelectedRepo = (selectedRepo) ->
  repoId = $(selectedRepo).data('id')

  $('.list-item').removeClass('active')
  $(selectedRepo).addClass('active')

  $('.repository-viewer').addClass('hide')
  $("##{repoId}").removeClass('hide').focus()
  $('title').text($("##{repoId}")[0].getTitle())
  this.activeRepo = repoId

# サイドバーを開閉する
global.toggleSidebar = ->
  $('#sidebar').toggleClass('collapsed')
  $('#webview-wrapper').toggleClass('full')

global.browserBack = -> getCurrentRepository()[0].goBack()
global.browserForward = -> getCurrentRepository()[0].goForward()
global.browserReload = -> getCurrentRepository()[0].reload()

# 次のレポジトリを選択する
global.nextRepo = ->
  $next = $('.repo.active').next()
  $next = $('.repo:first-child') unless $next.hasClass('repo')

  $next.click()

# 前のレポジトリを選択する
global.prevRepo = ->
  $prev = $('.repo.active').prev()
  $prev = $('.repo:last-child') unless $prev.hasClass('repo')

  $prev.click()

# プルリクエスト一覧を表示する
global.displayPR = ->
  url = new URL(getCurrentRepository()[0].src)
  path = url.pathname.split('/')
  account = path[1]
  repoName = path[2]

  getCurrentRepository().attr('src', "#{url.origin}/#{account}/#{repoName}/pulls")

# issues一覧を表示する
global.displayIssues = ->
  url = new URL(getCurrentRepository()[0].src)
  path = url.pathname.split('/')
  account = path[1]
  repoName = path[2]

  getCurrentRepository().attr('src', "#{url.origin}/#{account}/#{repoName}/issues")

# RP/検索ボックスを表示
global.displayPRIssueSearchBox = ->
  return if getCurrentRepository()[0] == undefined

  $('#pr-issue-search-box').removeClass('hide').focus()
  $('#black-screen').removeClass('hide')

# キーボードショートカット一覧を表示
global.displayKeyBoardShorCut = ->
  $('#cheatsheet').toggleClass('hide')
  $('#black-screen').toggleClass('hide')

  unless $('#cheatsheet').hasClass('hide')
    $('#cheatsheet').focus()

# レポジトリトップページを表示
global.displayRepositoryTopPage = -> getCurrentRepository().attr('src', getCurrentRepositoryUrl())

# 現在表示中のページURLをコピー
global.copycurrentUrl = ->
  require('clipboard').writeText(getCurrentRepository()[0].src)
  console.log getCurrentRepository()[0].src

global.renderApplication = ->
  loginUser = githubAuth(localStorage.getItem('githubAccessToken'))

  loginUser.repos (err, repos) ->
    filterRepositoryByPreference(repos)

    initializeActiveRepository()

    renderReposList()
    fadeOutLaunchLogo()

    $('.list-item').on 'click', ->
      $('#trending-repositories').remove()
      activateSelectedRepo(this)

# 今開いているレポジトリのjQueryオブジェクトを返す
global.getCurrentRepository = ->
  $('.repository-viewer:not(.hide)')

# 今開いているレポジトリのURLを取得する
global.getCurrentRepositoryUrl = ->
  url = new URL(getCurrentRepository()[0].src)
  path = url.pathname.split('/')
  account = path[1]
  repoName = path[2]

  "#{url.origin}/#{account}/#{repoName}"

global.displayTokenInput = ->
  $('.launch-text').addClass('hide')

  $('#token-input-wrapper').removeClass('hide')
  $('#token-input').focus()

# 現在見ているページをブラウザで開く
global.openInBrowser = ->
  require("shell").openExternal(getCurrentRepository()[0].src)
