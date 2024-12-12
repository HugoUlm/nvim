winget install --id=Neovim.Neovim  -e
winget install --id=junegunn.fzf  -e
winget install --id=BurntSushi.ripgrep.MSVC  -e
winget install -e --id LLVM.LLVM
winget install JanDeDobbeleer.OhMyPosh -s winget
winget install -e --id Git.Git
winget install -e --id OpenJS.NodeJS
winget install -e --id CoreyButler.NVMforWindows

git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.rb rebase
git config --global alias.vibe status
git config --global alias.yeet !git push origin HEAD
git config --global alias.oops reset --soft HEAD^
git config --global alias.yikes reset --hard HEAD^
git config --global alias.milk pull
git config --global alias.hide stash
git config --global alias.peek stash pop
git config --global alias.home swith main

winget install Microsoft.PowerToys -s winget

winget install --id=Microsoft.VisualStudio.2022.Professional -e

winget install --id=AutoHotkey.AutoHotkey -e
Start-Process "C:\Program Files\AutoHotkey\v2\AutoHotKey.exe" -ArgumentList "./remap.ahk"
$startupFolderPath = [System.IO.Path]::Combine($env:APPDATA, "Microsoft\Windows\Start Menu\Programs\Startup")
$shortcutPath = [System.IO.Path]::Combine($startupFolderPath, "remap.ahk.lnk")
$wshShell = New-Object -ComObject WScript.Shell
$shortcut = $wshShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "./remap.ahk"
$shortcut.Save()

Set-Location -Path "C:\Program Files\Neovim\bin"
mkdir lua
Set-Location -Path "C:\Program Files\Neovim\bin\lua"
git clone https://github.com/HugoUlm/dotfiles.git
ren dotfiles hugoulm

Set-Location -Path "C:\Users\wio950\AppData\Local"
mkdir nvim
cd ./nvim
git clone https://github.com/HugoUlm/dotfiles.git
ren dotfiles hugoulm
