#!/bin/bash
{
	echo "installing homebrew"
	mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip-components 1 -C homebrew
	echo "installing neovim"
	brew install neovim
	echo "installing fzf"
	brew install fzf
	echo "installing ripgrep"
	brew install ripgrep
	echo "installing gcc"
	brew install gcc
	brew tap homebrew/cask-fonts
	echo "installing oh-my-posh"
	brew install oh-my-posh
	echo "installing meslo"
	brew install --cask font-meslo-lg-nerd-font
	echo "installing ghostty"
	brew install ghostty
} || {
	export ex_code=$?
        (( $SAVED_OPT_E )) && set +e
        return $ex_code
}

echo "adding nvim config"
cd ~/.config/
mkdir nvim
git clone https://github.com/HugoUlm/dotfiles.git

echo "adding ghostty config"
cd ~/.config/
git clone https://github.com/HugoUlm/ghostty.git

echo "adding oh-my-posh config"
echo "eval \"$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/easy-term.omp.json)\"" >> ~/.zshrc

echo "adding git aliases"
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


