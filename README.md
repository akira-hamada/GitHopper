# GitHopper

GitHub multi repositories viewer application.
This application is especially useful when you browse multi github repositories, e.g. for code review. You don't need to open multi web browser tabs anymore by this app!
The app works with [Electron](http://electron.atom.io/).

IMG1(top)
IMG2(pref)
IMG3(PR/issue jump)
IMG4(cheatsheet)

# Features

- Displays your repositories in sidebar. (includes organization's repos you belongs to. this is a option)
- You can append any your favorite repos to the sidebar repo list.
- Switch repos with keyboard shortcut.
- App remember page state for each repos. (e.g. you see PRs page for a repo. then, you browse other repo's issues page. then, you can see PRs page again when you return to first repo)
- First launch page is Github Trendings page. (you can set other any page for this through pref)
- Jump to a specific PR or issue with a keyboard shortcut.

# How to use

1. Install the app
1. Input [Github access token](https://github.com/settings/tokens)
1. sign-in for a Github webpage (need this just once)
1. Done!! You would see your repos list and each Github page content


# Notes (issues)

- You need to sign-in for Github web page access after befing authorized. The app can't automatically sign-in for the Github web page with your access token. This is just once step.
- You need to reload the application to apply new preference. The App doesn't automatically apply your new preference for now.([The issue](https://github.com/akira-hamada/GitHopper/issues/26))
- Windows and linux are not checked.
- Github Enterprise is not supported for now.
- [some other issues](https://github.com/akira-hamada/GitHopper/issues)
