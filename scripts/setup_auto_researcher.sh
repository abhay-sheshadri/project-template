#!/bin/bash
set -e

source $HOME/.local/bin/env
source /root/.venv/bin/activate

cd /root

# Remove the extracted zip folders and re-clone from GitHub
rm -rf claude_query_me ai_config agent_orchestrator agent_sdk_viewer

git clone https://github.com/redwoodresearch/claude-query-me.git claude_query_me
git clone https://github.com/redwoodresearch/ryan_ai_config.git ai_config
git clone https://github.com/redwoodresearch/agent_orchestrator.git agent_orchestrator
git clone https://github.com/redwoodresearch/agent_viewer.git agent_sdk_viewer

# Install the orchestrator
cd /root/agent_orchestrator/agent_orchestrator
uv pip install .

# Install the agent SDK viewer
cd /root/agent_sdk_viewer/agent_sdk_viewer
uv pip install -e .

# Install claude-query-me
cd /root/claude_query_me/claude_query_me
uv pip install .
