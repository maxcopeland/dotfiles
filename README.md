# dotfiles
This contains all of the tools I need for day-to-day dev work.

## setup (mac)
1. Install [alacritty](https://alacritty.org/)<br>
   NOTE: Mac will complain about this Application if you double-click it. Instead, right-click, "open", and hit open.
2. Install [brew](https://brew.sh/)
3. `cd ~ && git clone https://github.com/maxcopeland/dotfiles.git`
4. `cd dotfiles && brew bundle install`
5. `chsh -s /bin/bash` and restart login shell
6. `cd ~/dotfiles/.config/nvim` && nvim
   NOTE: You only need to run nvim from within the `.config/nvim` directory once. After that, you can run `nvim` from anywhere.

