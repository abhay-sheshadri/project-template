#!/bin/bash
set -e  # Exit immediately if any command fails
set -u  # Exit if undefined variable is used
set -o pipefail  # Exit if any command in a pipeline fails

# Helper function to run commands with sudo if available
run_with_sudo() {
    if command -v sudo >/dev/null 2>&1; then
        sudo "$@"
    else
        "$@"
    fi
}

# Setup up the agents
bash scripts/setup_claude_code.sh

# Create a virtual environment
run_with_sudo rm -rf .venv
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env
uv python install 3.11
uv venv --clear
source .venv/bin/activate

uv pip install -e .

# Install and setup pre-commit hooks
uv pip install pre-commit
pre-commit install

# Other utils for development
run_with_sudo apt update
run_with_sudo apt install -y tmux gh
cp .tmux.conf ~/.tmux.conf

# Install claude+ wrapper
run_with_sudo cp scripts/claude+ /usr/local/bin/claude+
run_with_sudo chmod +x /usr/local/bin/claude+
