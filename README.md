# GitHopper

GitHub multi repositories viewer application. (Mac only for now)
This application is especially useful when you browse multi github repositories, e.g. for code review. You don't need to open multi web browser tabs anymore by this app!
The app works with [Electron](http://electron.atom.io/) 1.2.3.

![app_main](https://github.com/akira-hamada/GitHopper/blob/master/screenshots/githopper_1.png?raw=true)  
![app_pr_issue_search](https://github.com/akira-hamada/GitHopper/blob/master/screenshots/githopper_3.png?raw=true)  
![app_shortcuts](https://github.com/akira-hamada/GitHopper/blob/master/screenshots/githopper_4.png?raw=true)  
![app_preferences](https://github.com/akira-hamada/GitHopper/blob/master/screenshots/githopper_2.png?raw=true)  

# Features

- Displays your repositories in sidebar.
- You can append any your favorite repos to the sidebar repo list.
- Switch repos with keyboard shortcut.
- App remember page state for each repos. (e.g. you see PRs page for a repo. then, you browse other repo's issues page. then, you can see PRs page again when you return to first repo)
- First launch page is Github Trendings page. (you can set other any page for this through pref)
- Jump to a specific PR or issue with a keyboard shortcut.

# How to use

1. [Download](https://github.com/akira-hamada/GitHopper/releases/download/1.0.0/GitHopper.app.zip) and launch the app
1. Input [Github access token](https://github.com/settings/tokens)
1. sign-in for a Github webpage (need this just once)
1. Done!! You would see your repos list and each Github page content


# Notes (issues)

- You need to sign-in for Github web page access after befing authorized. The app can't automatically sign-in for the Github web page with your access token. This is just once step.
- You need to reload the application to apply new preference. The App doesn't automatically apply your new preference for now.([The issue](https://github.com/akira-hamada/GitHopper/issues/26))
- Windows and linux are not checked.
- Github Enterprise is not supported for now.
- [some other issues](https://github.com/akira-hamada/GitHopper/issues)

# License

GitHopper is released under the [MIT License](http://www.opensource.org/licenses/MIT).
