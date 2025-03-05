#!/bin/bash
{
	mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip-components 1 -C homebrew
	brew install neovim
	brew install fzf
	brew install ripgrep
	brew install gcc
	brew tap homebrew/cask-fonts
	brew install oh-my-posh
	brew install --cask font-meslo-lg-nerd-font
} || {
	export ex_code=$?
        (( $SAVED_OPT_E )) && set +e
        return $ex_code
}

git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.rb rebase
git config --global alias.vibe status
git config --global alias.yeet "!git push origin HEAD"
git config --global alias.oops "reset --soft HEAD^"
git config --global alias.yikes "reset --hard HEAD^"
git config --global alias.milk pull
git config --global alias.hide stash
git config --global alias.peek "stash pop"
git config --global alias.home "switch main"


