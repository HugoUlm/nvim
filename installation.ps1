winget install --id=Neovim.Neovim  -e
winget install --id=junegunn.fzf  -e
winget install --id=BurntSushi.ripgrep.MSVC  -e
winget install -e --id LLVM.LLVM
winget install JanDeDobbeleer.OhMyPosh -s winget
winget install -e --id Git.Git

git config --global alias.co checkout
git config --gloabl alias.ci commit
git config --gloabl alias.rb rebase
git config --gloabl alias.vibe status
git config --gloabl alias.yeet !git push origin HEAD
git config --gloabl alias.oops reset --soft HEAD^
git config --gloabl alias.yikes reset --hard HEAD^
git config --gloabl alias.milk pull
git config --gloabl alias.hide stash
git config --gloabl alias.peek stash pop
git config --gloabl alias.home swith main

winget install Microsoft.PowerToys -s winget

winget install --id=AutoHotkey.AutoHotkey  -e
Start-Process "C:\Program Files\AutoHotkey\v2\AutoHotKey.exe" -ArgumentList "./remap.ahk"
$startupFolderPath = [System.IO.Path]::Combine($env:APPDATA, "Microsoft\Windows\Start Menu\Programs\Startup")
$shortcutPath = [System.IO.Path]::Combine($startupFolderPath, "remap.ahk.lnk")
$wshShell = New-Object -ComObject WScript.Shell
$shortcut = $wshShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "./remap.ahk"
$shortcut.Save()
