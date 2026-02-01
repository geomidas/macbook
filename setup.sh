#!/bin/bash

set -e

echo "🚀 Starting macOS environment setup..."

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script is designed for macOS only"
    exit 1
fi

# Install Xcode command line tools
echo "📦 Installing Xcode command line tools..."
if ! xcode-select -p &> /dev/null; then
    xcode-select --install
    echo "⏳ Waiting for Xcode command line tools installation..."
    echo "   Please complete the installation in the dialog that appears"
    echo "   Press Enter when installation is complete..."
    read -r
else
    echo "✅ Xcode command line tools already installed"
fi

# Install Homebrew
echo "🍺 Installing Homebrew..."
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for current session
    if [[ "$(uname -m)" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    echo "✅ Homebrew installed"
else
    echo "✅ Homebrew already installed"
fi

# Install Ansible
echo "🤖 Installing Ansible..."
if ! command -v ansible &> /dev/null; then
    brew install ansible
    echo "✅ Ansible installed"
else
    echo "✅ Ansible already installed"
fi

# Run Ansible playbook
echo "🎯 Running Ansible playbook to configure development environment..."
ansible-playbook site.yml

echo "🎉 Setup complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Restart your terminal or run 'source ~/.zshrc'"
echo "   2. Configure iTerm2 font: Preferences > Profiles > Text > Change Font > Select 'Hack Nerd Font'"
echo "   3. Run 'p10k configure' if you want to customize the Powerlevel10k theme"
