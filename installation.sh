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
