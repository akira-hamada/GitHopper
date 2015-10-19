//----------------------------------
// electronアプリの初期化処理
//----------------------------------

'use strict';

var app = require('app');
var BrowserWindow = require('browser-window');
var Menu = require('menu');

require('crash-reporter').start();

var mainWindow = null;
var prefWindow = null;

app.on('window-all-closed', function() {
  if (process.platform != 'darwin')
    app.quit();
});

// アプリが読み込まれた時の処理
app.on('ready', function() {

  // メニューをアプリケーションに追加
  Menu.setApplicationMenu(menu);

  // ブラウザ(Chromium)の起動, 初期画面のロード
  mainWindow = new BrowserWindow({width: 1200, height: 700});
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
      { label: 'Preferences', accelerator: 'Command+,', click: function () {
          // ブラウザ(Chromium)の起動, 初期画面のロード
          prefWindow = new BrowserWindow({width: 500, height: 400, resizable: false});
          prefWindow.loadUrl('file://' + __dirname + '/preference.html');
          prefWindow.on('closed', function() { prefWindow = null; });
        }
      },
      { type: 'separator' },
      { label: 'Quit GitHub Viewer', accelerator: 'Command+Q', click: function () { app.quit(); } },
    ]
  },
  {
    label: 'Edit',
    submenu: [
      { label: 'Cut', accelerator: 'Cmd+X', selector: 'cut:' },
      { label: 'Copy', accelerator: 'Cmd+C', selector: 'copy:' },
      { label: 'Paste', accelerator: 'Cmd+V', selector: 'paste:' },
      { label: 'Select All', accelerator: 'Cmd+A', selector: 'selectAll:' },
    ]
  },
  {
    label: 'View',
    submenu: [
      { label: 'Close', accelerator: 'Command+W', click: function() { BrowserWindow.getFocusedWindow().close(); } },
      { label: 'Reload App', accelerator: 'Shift+Command+R', click: function() { BrowserWindow.getFocusedWindow().reloadIgnoringCache(); } },
      { label: 'Toggle DevTools', accelerator: 'Alt+Command+I', click: function() { BrowserWindow.getFocusedWindow().toggleDevTools(); } },
      // { label: 'サイドバーを開閉', accelerator: 'Command+H', click: function() { BrowserWindow.getFocusedWindow().toggleSidebar(); } }
    ]
  },
];

var menu = Menu.buildFromTemplate(template);
