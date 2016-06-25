remote = require('electron').remote

# トークン認証後の処理
global.afterValidateToken = (token, successCallback, failureCallback) ->
  user = githubAuth(token)

  user.listNotifications (err, notifcations) ->
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

  appendRepositories()
  removeRepositories()

# レポジトリを追加する
global.appendRepositories = ->
  return unless localStorage.getItem('append-repos')? && localStorage.getItem('append-repos') != ''

  repos = localStorage.getItem('append-repos').split(/\s*?,\s*/)

  for repo in repos
    this.repos.push {
      html_url: "https://github.com/#{repo}",
      name: repo.split('/')[1] || repo.split('/')[0],
      id: repo.replace('/', '-')
    }

# レポジトリを削除する
global.removeRepositories = ->
  return unless localStorage.getItem('remove-repos')? && localStorage.getItem('remove-repos') != ''

  reposToRemove = localStorage.getItem('remove-repos').split(/\s*?,\s*/)
  this.repos = this.repos.filter (repo) ->
    # リストから削除したいレポジトリ名の配列にrepo.nameが含まれていればtrue
    reposToRemove.indexOf(repo.name) == -1

# アクティブなレポジトリを初期化する
global.initializeActiveRepository = ->
  this.activeRepo = null

# レポジトリ一覧を表示する
global.renderReposList = ->
  $('#webview-wrapper').append("<webview id='after-launch-view' class='repository-viewer invisible' src='#{afterLaunchUrl()}' autosize='on'></webview>")

  for repo in this.repos
    $('#repositories').append("<li class='list-item repo displayed' data-url='#{repo.html_url}' data-repo='#{repo.name}' data-id='#{repo.id}'><span class='octicon octicon-repo text-muted'></span>#{repo.name}</li>")
    $('#webview-wrapper').append("<webview id='#{repo.id}' class='repository-viewer hide' src='#{repo.html_url}' autosize='on'></webview>")

  $('webview').on 'did-start-loading', -> $('title').text('Loading...')
  $('webview').on 'did-stop-loading', -> $('title').text($(this)[0].getTitle())
  $('webview').on 'new-window', -> require('electron').shell.openExternal(event.url)
  $('#repo-search-input').on 'keyup', searchRepositories

# スプラッシュロゴを非表示にする
global.fadeOutLaunchLogo = ->
  $('#launch-logo').fadeOut 'fast', ->
    $(this).remove()
    $('#sidebar').removeClass('hide')
    $('#after-launch-view').removeClass('invisible').focus().addClass('active')
    $('body').css('background-color', 'white')

# 選択されたレポジトリを表示する
global.activateSelectedRepo = (selectedRepo) ->
  repoId = $(selectedRepo).data('id')

  $('.list-item').removeClass('active')
  $(selectedRepo).addClass('active')

  $('.repository-viewer').addClass('hide').removeClass('active')
  $("##{repoId}").removeClass('hide').focus().addClass('active')
  $('title').text($("##{repoId}")[0].getTitle())

  this.activeRepo = repoId
  height = remote.getCurrentWindow().getSize()[1]
  width = $(window).width()
  window.resizeTo(width + 1, height)
  window.resizeTo(width, height)

# サイドバーを開閉する
global.toggleSidebar = ->
  $('#sidebar').toggleClass('collapsed')

global.browserBack = -> getCurrentRepository()[0].goBack()
global.browserForward = -> getCurrentRepository()[0].goForward()
global.browserReload = -> getCurrentRepository()[0].reload()

# 次のレポジトリを選択する
global.nextRepo = ->
  $next = $('.repo.active').nextAll('.repo.displayed').first()
  $next = $('.repo.displayed').first() if $next.length <= 0 # 既にリスト中で最後の表示されているレポジトリを選択中の場合
  return if $next.length <= 0 # 表示中のレポジトリが一つもない場合

  $next.click()

# 前のレポジトリを選択する
global.prevRepo = ->
  $prev = $('.repo.active').prevAll('.repo.displayed').first() # 最後のdisplayedが配列中の最初に入るためfirstを使用
  $prev = $('.repo.displayed').last() if $prev.length <= 0 # 既にリストで最初の表示されているレポジトリを選択中の場合
  return if $prev.length <= 0 # 表示中のレポジトリが一つもない場合

  $prev.click()

# プルリクエスト一覧を表示する
global.displayPR = ->
  if getCurrentRepository()[0].id == 'after-launch-view'
    return

  url = new URL(getCurrentRepository()[0].getURL())
  path = url.pathname.split('/')
  account = path[1]
  repoName = path[2]

  getCurrentRepository().attr('src', "#{url.origin}/#{account}/#{repoName}/pulls")

# closed プルリクエスト一覧を表示する
global.displayClosedPR = ->
  if getCurrentRepository()[0].id == 'after-launch-view'
    return

  url = new URL(getCurrentRepository()[0].getURL())
  path = url.pathname.split('/')
  account = path[1]
  repoName = path[2]

  getCurrentRepository().attr('src', "#{url.origin}/#{account}/#{repoName}/pulls?q=is%3Apr+is%3Aclosed")

# issues一覧を表示する
global.displayIssues = ->
  if getCurrentRepository()[0].id == 'after-launch-view'
    return

  url = new URL(getCurrentRepository()[0].getURL())
  path = url.pathname.split('/')
  account = path[1]
  repoName = path[2]

  getCurrentRepository().attr('src', "#{url.origin}/#{account}/#{repoName}/issues")

# closed issues一覧を表示する
global.displayClosedIssues = ->
  if getCurrentRepository()[0].id == 'after-launch-view'
    return

  url = new URL(getCurrentRepository()[0].getURL())
  path = url.pathname.split('/')
  account = path[1]
  repoName = path[2]

  getCurrentRepository().attr('src', "#{url.origin}/#{account}/#{repoName}/issues?q=is%3Aissue+is%3Aclosed")

# RP/検索ボックスを表示
global.displayPRIssueSearchBox = ->
  if getCurrentRepository()[0] == undefined || getCurrentRepository()[0].id == 'after-launch-view'
    return

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
  require('electron').clipboard.writeText(getCurrentRepository()[0].getURL())
  console.log getCurrentRepository()[0].getURL()

global.renderApplication = ->
  loginUser = githubAuth(localStorage.getItem('githubAccessToken'))

  loginUser.listRepos (err, repos) ->
    filterRepositoryByPreference(repos)

    initializeActiveRepository()

    renderReposList()
    fadeOutLaunchLogo()

    $('.list-item').on 'click', ->
      activateSelectedRepo(this)

# 今開いているレポジトリのjQueryオブジェクトを返す
global.getCurrentRepository = ->
  $('.repository-viewer.active')

# 今開いているレポジトリのURLを取得する
global.getCurrentRepositoryUrl = ->
  url = new URL(getCurrentRepository()[0].getURL())
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
  require('electron').shell.openExternal(getCurrentRepository()[0].getURL())

# ページ内検索ボックスを表示
global.displayTextSearchBox = ->
  $('#text-search-wrapper').addClass('displayed')
  $('#text-search-input').focus().select()

# ページ内検索ボックスを隠す
global.hideTextSearchBox = ->
  $('#text-search-wrapper').removeClass('displayed')
  getCurrentRepository().focus()

# ページ内検索を実行する
global.searchText = (query, isBackward) ->
  getCurrentRepository()[0].executeJavaScript("window.find('#{query}', false, #{isBackward}, true)")

# レポジトリ検索を実行する
global.searchRepositories = (event) ->
  query = $(this).val().toLowerCase()
  $("#repositories .repo").addClass('displayed')
  unless query == ''
    $unMatchedRepos = $('#repositories .repo').filter ->
      $(this).attr('data-repo').toLowerCase().indexOf(query) < 0

    $unMatchedRepos.removeClass('displayed')

  if event.keyCode == 13 # enter key押下時
    activateSelectedRepo("#repositories .repo.displayed:first") # // 表示されている一番植のレポジトリ
    $('#repositories .repo').addClass('displayed')
    $('#repo-search-input').val('')

  if event.keyCode == 27 # esc key押下時
    $('#repositories .repo').addClass('displayed')
    $('#repo-search-input').val('')

# レポジトリ検索ボックスにフォーカスする
global.focusToRepoSearch = ->
  $('#repo-search-input').focus().select()

# 起動後に表示するページのURL
global.afterLaunchUrl = ->
  if localStorage.getItem('after-launch')? && localStorage.getItem('after-launch') != ''
    localStorage.getItem('after-launch')
  else
    'https://github.com/trending'

# 初期画面をもう一度表示
global.displayInitialView = ->
  $('.repository-viewer').addClass('hide').removeClass('active')
  $('#after-launch-view').removeClass('hide').focus().addClass('active')
  $('title').text($('#after-launch-view')[0].getTitle())
  $('.list-item').removeClass('active')
  height = remote.getCurrentWindow().getSize()[1]
  width = $(window).width()
  window.resizeTo(width + 1, height)
  window.resizeTo(width, height)
