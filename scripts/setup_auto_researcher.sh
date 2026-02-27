#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source $HOME/.local/bin/env
source "${PROJECT_ROOT}/.venv/bin/activate"

cd "$PROJECT_ROOT"

# Remove the extracted zip folders and re-clone from GitHub
rm -rf claude_query_me ai_config agent_orchestrator agent_sdk_viewer

git clone https://github.com/redwoodresearch/claude-query-me.git claude_query_me
git clone https://github.com/redwoodresearch/ryan_ai_config.git ai_config
git clone https://github.com/redwoodresearch/agent_orchestrator.git agent_orchestrator
git clone https://github.com/redwoodresearch/agent_viewer.git agent_sdk_viewer

# Install the orchestrator
uv pip install -e "${PROJECT_ROOT}/agent_orchestrator/agent_orchestrator"

# Install the agent SDK viewer
uv pip install -e "${PROJECT_ROOT}/agent_sdk_viewer/agent_sdk_viewer"

# Install claude-query-me
uv pip install -e "${PROJECT_ROOT}/claude_query_me/claude_query_me"
