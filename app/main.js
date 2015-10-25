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
      { label: 'Preferences', accelerator: 'Cmd+,', click: function () {
          // ブラウザ(Chromium)の起動, 初期画面のロード
          prefWindow = new BrowserWindow({width: 500, height: 400, resizable: false});
          prefWindow.loadUrl('file://' + __dirname + '/preference.html');
          prefWindow.on('closed', function() { prefWindow = null; });
        }
      },
      { type: 'separator' },
      { label: 'Quit GitHub Viewer', accelerator: 'Cmd+Q', click: function () { app.quit(); } },
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
    label: 'History',
    submenu: [
      { label: 'Back', accelerator: 'CmdOrCtrl+Left', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'Cmd+left'); } },
      { label: 'Forward', accelerator: 'CmdOrCtrl+Right', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'Cmd+right'); } },
      { label: 'Reload', accelerator: 'CmdOrCtrl+R', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'Cmd+r'); } },
      { type: 'separator' },
      { label: 'Copy Current Page URL', accelerator: 'CmdOrCtrl+U', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'Cmd+u'); } },
      { label: 'Open In Browser', accelerator: 'CmdOrCtrl+O', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'Cmd+o'); } },
    ]
  },
  {
    label: 'View',
    submenu: [
      { label: 'Close', accelerator: 'Cmd+W', click: function() { BrowserWindow.getFocusedWindow().close(); } },
      { label: 'Reload App', accelerator: 'Shift+Cmd+R', click: function() { BrowserWindow.getFocusedWindow().reloadIgnoringCache(); } },
      { label: 'Toggle DevTools', accelerator: 'Alt+Cmd+I', click: function() { BrowserWindow.getFocusedWindow().toggleDevTools(); } },
      { label: 'Toggle Sidebar', accelerator: 'CmdOrCtrl+S', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'Cmd+s'); } },
      { type: 'separator' },
      { label: 'Previous Repository', accelerator: 'CmdOrCtrl+K', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'Cmd+k'); } },
      { label: 'Next Repository', accelerator: 'CmdOrCtrl+J', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'Cmd+j'); } },
      { label: 'First Repository', accelerator: 'CmdOrCtrl+1', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'Cmd+1'); } },
      { label: 'Last Repository', accelerator: 'CmdOrCtrl+9', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'Cmd+9'); } },
      { type: 'separator' },
      { label: 'Keyboard Shortcuts', accelerator: 'CmdOrCtrl+/', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'Cmd+/'); } },
    ]
  },
  {
    label: 'Repository',
    submenu: [
      { label: 'PR/Issue Search', accelerator: 'CmdOrCtrl+F', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'Cmd+f'); } },
      { label: 'Repository Top',  accelerator: 'CmdOrCtrl+T', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'Cmd+t'); } },
      { type: 'separator' },
      { label: 'Pull Requests',   accelerator: 'CmdOrCtrl+P', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'Cmd+p'); } },
      { label: 'Closed Pull Requests',   accelerator: 'Shift+CmdOrCtrl+P', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'Cmd+shift+p'); } },
      { type: 'separator' },
      { label: 'Issues',          accelerator: 'CmdOrCtrl+I', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'Cmd+i'); } },
      { label: 'Closed Issues',          accelerator: 'Shift+CmdOrCtrl+I', click: function() { mainWindow.webContents.send('onShortcutTriggered', 'Cmd+shift+i'); } },
    ]
  },
];

var menu = Menu.buildFromTemplate(template);
