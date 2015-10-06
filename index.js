//----------------------------------
// electronアプリの初期化処理
//----------------------------------

'use strict';

var app = require('app');
var BrowserWindow = require('browser-window');
var Menu = require('menu');

require('crash-reporter').start();

var mainWindow = null;

app.on('window-all-closed', function() {
  if (process.platform != 'darwin')
    app.quit();
});

// アプリが読み込まれた時の処理
app.on('ready', function() {

  // メニューをアプリケーションに追加
  Menu.setApplicationMenu(menu);

  // ブラウザ(Chromium)の起動, 初期画面のロード
  mainWindow = new BrowserWindow({width: 800, height: 600});
  mainWindow.loadUrl('file://' + __dirname + '/index.html');

  // ウィンドウが閉じた時の処理
  mainWindow.on('closed', function() {
    mainWindow = null;
  });
});

var template = [
  {
    label: 'GitHub Viewer',
    submenu: [
      { label: 'GitHub Viewerを終了', accelerator: 'Command+Q', click: function () { app.quit(); } }
    ]
  },
  {
    label: 'ビュー',
    submenu: [
      { label: '再読み込み', accelerator: 'Command+R', click: function() { BrowserWindow.getFocusedWindow().reloadIgnoringCache(); } },
      { label: '開発者ツール', accelerator: 'Alt+Command+I', click: function() { BrowserWindow.getFocusedWindow().toggleDevTools(); } }
    ]
  },
];

var menu = Menu.buildFromTemplate(template);
