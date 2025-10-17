#!/bin/bash

# Homebrew
## Install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off

## Taps
echo "Tapping Brew..."
brew tap FelixKratz/formulae
brew tap hashicorp/tap


## Formulae
echo "Installing Brew Formulae..."

### CLI Essentials
brew install wget
brew install ripgrep
brew install fd
brew install jq
brew install gh

### Window Management & Desktop
brew install sketchybar    # Customizable menu bar
brew install borders       # Window borders for focus indication

### Terminal Enhancement
brew install tmux
brew install neovim
brew install tree-sitter
brew install starship
brew install zsh-autosuggestions
brew install zsh-fast-syntax-highlighting
brew install zoxide
brew install fzf
brew install btop
brew install midnight-commander
brew install luarocks
brew install postgresql@17

### Security & Network
brew install nmap          # Network scanner
brew install lulu          # Firewall application
brew install wireguard-go  # VPN protocol
brew install gnupg
brew install --cask veracrypt

### Development Tools
brew install volta         # JavaScript toolchain manager (Node.js/npm)
brew install uv            # Python package installer
brew install ruff          # Python linter
brew install go
brew install ollama
brew install docker
brew install hashicorp/tap/terraform
brew install act           # GitHub Actions runner

volta install node npm pnpm yarn
npm install -g neovim

uv tool install pynvim

### Database
brew install sqlite

### Language servers
brew install lua-language-server
brew install pyright
brew install typescript-language-server
brew install yaml-language-server
brew install terraform-ls


## Casks
echo "Installing Brew Casks..."

### Terminal & Window Management
brew install --cask ghostty                      # GPU-accelerated terminal emulator
brew install --cask nikitabobko/tap/aerospace    # Tiling window manager
brew install --cask mediosz/tap/swipeaerospace   # Gesture support for aerospace

brew install --cask meetingbar

### Media
brew install --cask vlc                          # Media player

### Communication
brew install --cask zoom                       # Video conferencing
brew install --cask google-chrome               # Browser

### Security
brew install --cask keepassxc                  # Password manager

### Utilities
brew install --cask logi-options+              # Logitech device customization

### Development
brew install --cask orbstack                   # Container & VM manager
brew install --cask datagrip

brew install gitleaks                     # Secret scanner for git

# AWS CLI (manual install)
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg ./AWSCLIV2.pkg -target /

### Fonts
brew install --cask sf-symbols           # Apple SF Symbols
brew install --cask font-sf-mono         # Apple SF Mono
brew install --cask font-sf-pro          # Apple SF Pro
brew install --cask font-hack-nerd-font  # Hack Nerd Font (patched)
brew install --cask font-jetbrains-mono  # JetBrains Mono
brew install --cask font-fira-code       # Fira Code (ligatures)

# Mac App Store Apps
echo "Installing Mac App Store Apps..."
mas install 1451685025 #Wireguard
mas install 497799835 #xCode


# macOS Settings

## Network & Storage
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1  # Enable network browsing on all interfaces
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true  # Prevent .DS_Store files on network volumes
defaults write com.apple.spaces spans-displays -bool false  # Separate spaces per display

## Dock
defaults write com.apple.dock autohide -bool true  # Auto-hide dock
defaults write com.apple.dock "mru-spaces" -bool "false"  # Disable automatic space rearrangement

## UI & Performance
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false  # Disable window animations
defaults write -g NSWindowShouldDragOnGesture -bool true  # Enable window dragging with Ctrl+Cmd
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false  # Disable auto-correct
defaults write NSGlobalDomain AppleShowAllExtensions -bool true  # Show all file extensions
defaults write NSGlobalDomain _HIHideMenuBar -bool true  # Auto-hide menu bar
defaults write NSGlobalDomain KeyRepeat -int 1  # Fast key repeat rate

## Screenshots
defaults write com.apple.screencapture location -string "$HOME/Desktop"  # Save screenshots to Desktop
defaults write com.apple.screencapture disable-shadow -bool true  # Disable window shadow in screenshots
defaults write com.apple.screencapture type -string "png"  # Screenshot format: PNG

## Finder
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false  # Hide external drives on desktop
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false  # Hide hard drives on desktop
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false  # Hide network servers on desktop
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false  # Hide removable media on desktop
defaults write com.apple.Finder AppleShowAllFiles -bool true  # Show hidden files
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"  # Search current folder by default
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false  # Disable extension change warning
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true  # Show full path in Finder title
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"  # Default to list view
defaults write com.apple.finder ShowStatusBar -bool false  # Hide status bar
defaults write com.apple.finder SidebarShowingiCloudDesktop -bool true

## Time Machine
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true  # Don't prompt for new backup disks

## Safari & Web
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false  # Disable auto-open of safe downloads
defaults write com.apple.Safari IncludeDevelopMenu -bool true  # Enable Develop menu
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true  # Enable Web Inspector
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true  # Enable developer extras
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true  # Enable global web developer extras

## Mail
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false  # Copy email addresses without names



## Fix for MX Master 3S
sudo defaults write /Library/Preferences/com.apple.airport.bt.plist bluetoothCoexMgmt Hybrid


# Start services
brew services start sketchybar
brew services start borders

# Links and config files
ln -sfn /opt/homebrew/bin/python3 /opt/homebrew/bin/python
ln -sf "$HOME/.config/zsh/.zshrc" "$HOME/.zshrc"

# Midnight Commander skin
mkdir -p "$HOME/.local/share/mc/skins"
ln -sf "$HOME/.config/mc/mashdark.ini" "$HOME/.local/share/mc/skins/mashdark.ini"

