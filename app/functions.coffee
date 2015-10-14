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
  for repo in this.repos
    $('#repositories').append("<li class='list-item repo' data-url='#{repo.html_url}' data-repo='#{repo.name}' data-id='#{repo.id}'><span class='octicon octicon-repo text-muted'></span>#{repo.name}</li>")
    $('#webview-wrapper').append("<webview id='#{repo.id}' class='repository-viewer hide' src='#{repo.html_url}' autosize='on'></webview>")

  $('#sidebar').nanoScroller
    contentClass: 'scroll-content'
    paneClass: 'scroll-pane'

# スプラッシュロゴを非表示にする
global.fadeOutLaunchLogo = ->
  $('#launch-logo').fadeOut 'normal', ->
    $(this).remove()
    $('#sidebar').removeClass('collapsed')
    $('#default-webview').removeClass('invisible')
    $('body').css('background-color', 'white')

# 選択されたレポジトリを表示する
global.activateSelectedRepo = (selectedRepo) ->
  repoId = $(selectedRepo).data('id')

  $('.list-item').removeClass('active')
  $(selectedRepo).addClass('active')

  $('.repository-viewer').addClass('hide')
  $("##{repoId}").removeClass('hide')
  this.activeRepo = repoId

# サイドバーを開閉する
global.toggleSidebar = ->
  $('#sidebar').toggleClass('collapsed')
  $('#default-webview').toggleClass('full')
  $('#webview-wrapper').toggleClass('full')

global.browserBack = -> $('.repository-viewer:not(.hide)')[0].goBack()
global.browserForward = -> $('.repository-viewer:not(.hide)')[0].goForward()
global.browserReload = -> $('.repository-viewer:not(.hide)')[0].reload()

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
  url = new URL($('.repository-viewer:not(.hide)')[0].src)
  path = url.pathname.split('/')
  account = path[1]
  repoName = path[2]

  $('.repository-viewer:not(.hide)').attr('src', "#{url.origin}/#{account}/#{repoName}/pulls")

# issues一覧を表示する
global.displayIssues = ->
  url = new URL($('.repository-viewer:not(.hide)')[0].src)
  path = url.pathname.split('/')
  account = path[1]
  repoName = path[2]

  $('.repository-viewer:not(.hide)').attr('src', "#{url.origin}/#{account}/#{repoName}/issues")

global.renderApplication = ->
  loginUser = githubAuth(localStorage.getItem('githubAccessToken'))

  loginUser.repos (err, repos) ->
    filterRepositoryByPreference(repos)

    initializeActiveRepository()

    renderReposList()
    fadeOutLaunchLogo()

    $('.list-item').on 'click', ->
      $('#default-webview').remove()
      activateSelectedRepo(this)

global.displayTokenInput = ->
  $('.launch-text').addClass('hide')

  # #token-inputにフォーカスしている場合のみ、 returnキー押下で値を取得する
  #   https://github.com/madrobby/keymaster#filter-key-presses
  $('#token-input').on 'focus', ->
    key.filter = (event) ->
      tagName = (event.target || event.srcElement).tagName
      key.setScope(/^INPUT$/.test(tagName) ? 'input' : 'other')

      return true

    key '⌘+a, ctrl+a', => $(this).select()
    key '⌘+v, ctrl+v', => $(this).val(Clipboard.readText())
    key '⌘+c, ctrl+c', => Clipboard.writeText($(this).val())
    key '⌘+x, ctrl+x', =>
      Clipboard.writeText($(this).val())
      $(this).val('')

    key 'return', =>
      # トークンがinvalidな時の処理を追加
      if $(this).val() != ''
        afterValidateToken $(this).val(),
          =>
            $('.input-err-msg').addClass('hide')
            localStorage.setItem('githubAccessToken', $(this).val())
            $(this).val('')
            renderApplication()
          =>
            $('.input-err-msg').removeClass('hide')

  $('#token-input-wrapper').removeClass('hide')
  $('#token-input').focus()
