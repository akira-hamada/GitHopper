//----------------------------------
// electronアプリの初期化処理
//
// アプリのパッケージ方法
// electron-packager ./github-viewer 'GitHopper' --platform=darwin,linux --arch=x64 --version=0.30.0 --icon=github-viewer/icons/githopper_icon_1.icns
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

if (process.platform == 'darwin') { // CmdOrCtrl+Z がパッケージしたMacで動作しないための分岐 (TODO linuxやwindowsでの動作確認)
  var undoShortCut = 'Cmd+Z'
} else {
  var undoShortCut = 'Ctrl+Z'
}

var template = [
  {
    label: 'GitHopper',
    submenu: [
      { label: 'Preferences', accelerator: 'CmdOrCtrl+,', click: function () {
          // ブラウザ(Chromium)の起動, 初期画面のロード
          if(prefWindow == null) {
            prefWindow = new BrowserWindow({width: 500, height: 400, resizable: false});
            prefWindow.loadUrl('file://' + __dirname + '/preference.html');
            prefWindow.on('closed', function() { prefWindow = null; });
          }
        }
      },
      { type: 'separator' },
      { label: 'Quit GitHopper', accelerator: 'CmdOrCtrl+Q', click: function () { app.quit(); } },
    ]
  },
  {
    label: 'Edit',
    submenu: [
      { label: 'Undo', accelerator: undoShortCut, click: function() { mainWindow.webContents.undo(); } }, // CmdOrCtrl+Z がパッケージしたMacで動作しないための分岐 (TODO linuxやwindowsでの動作確認)
      { label: 'Undo', accelerator: 'Shift+'+undoShortCut, click: function() { mainWindow.webContents.redo(); } }, // CmdOrCtrl+Z がパッケージしたMacで動作しないための分岐 (TODO linuxやwindowsでの動作確認)
      { type: 'separator' },
      { label: 'Cut', accelerator: 'CmdOrCtrl+X', selector: 'cut:' },
      { label: 'Copy', accelerator: 'CmdOrCtrl+C', selector: 'copy:' },
      { label: 'Paste', accelerator: 'CmdOrCtrl+V', selector: 'paste:' },
      { label: 'Select All', accelerator: 'CmdOrCtrl+A', selector: 'selectAll:' },
      { type: 'separator' },
      { label: 'Find', accelerator: 'CmdOrCtrl+F', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'f'); } },
    ]
  },
  {
    label: 'History',
    submenu: [
      { label: 'Back', accelerator: 'CmdOrCtrl+Left', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'left'); } },
      { label: 'Forward', accelerator: 'CmdOrCtrl+Right', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'right'); } },
      { label: 'Reload', accelerator: 'CmdOrCtrl+R', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'r'); } },
      { type: 'separator' },
      { label: 'Copy Current Page URL', accelerator: 'CmdOrCtrl+U', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'u'); } },
      { label: 'Open In Browser', accelerator: 'CmdOrCtrl+O', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'o'); } },
    ]
  },
  {
    label: 'View',
    submenu: [
      { label: 'New Window', accelerator: 'CmdOrCtrl+N', click: function() {
        if(mainWindow == null) {
          mainWindow = new BrowserWindow({width: 1200, height: 700});
          mainWindow.loadUrl('file://' + __dirname + '/index.html');
        }
      } },
      { label: 'Close', accelerator: 'CmdOrCtrl+W', click: function() { BrowserWindow.getFocusedWindow().close(); } },
      { label: 'Reload App', accelerator: 'Shift+CmdOrCtrl+R', click: function() { BrowserWindow.getFocusedWindow().reloadIgnoringCache(); } },
      { label: 'Toggle DevTools', accelerator: 'Alt+CmdOrCtrl+I', click: function() { BrowserWindow.getFocusedWindow().toggleDevTools(); } },
      { label: 'Toggle Sidebar', accelerator: 'CmdOrCtrl+S', click: function() { mainWindow.webContents.send('onShortcutTriggered', 's'); } },
      { type: 'separator' },
      { label: 'Previous Repository', accelerator: 'CmdOrCtrl+K', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'k'); } },
      { label: 'Next Repository', accelerator: 'CmdOrCtrl+J', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'j'); } },
      { label: 'First Repository', accelerator: 'CmdOrCtrl+1', click: function() { mainWindow.webContents.send('onShortcutTriggered', '1'); } },
      { label: 'Last Repository', accelerator: 'CmdOrCtrl+9', click: function() { mainWindow.webContents.send('onShortcutTriggered', '9'); } },
      { type: 'separator' },
      { label: 'Keyboard Shortcuts', accelerator: 'CmdOrCtrl+/', click: function() { mainWindow.webContents.send('onShortcutTriggered', '/'); } },
    ]
  },
  {
    label: 'Repository',
    submenu: [
      { label: 'PR/Issue Search', accelerator: 'CmdOrCtrl+G', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'g'); } },
      { label: 'Repository Top',  accelerator: 'CmdOrCtrl+T', click: function() { mainWindow.webContents.send('onShortcutTriggered', 't'); } },
      { type: 'separator' },
      { label: 'Pull Requests',   accelerator: 'CmdOrCtrl+P', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'p'); } },
      { label: 'Closed Pull Requests',   accelerator: 'Shift+CmdOrCtrl+P', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'shift+p'); } },
      { type: 'separator' },
      { label: 'Issues',          accelerator: 'CmdOrCtrl+I', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'i'); } },
      { label: 'Closed Issues',          accelerator: 'Shift+CmdOrCtrl+I', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'shift+i'); } },
    ]
  },
];

var menu = Menu.buildFromTemplate(template);
