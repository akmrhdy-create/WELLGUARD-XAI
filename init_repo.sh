#!/usr/bin/env bash
set -euo pipefail

# init_repo.sh — Initialize a local git repo, create initial files, commit, and push to remote
# Usage: ./init_repo.sh
# Requires: git installed, access to the remote repo (HTTPS or SSH). If using HTTPS and GitHub requires a PAT, use Git credential helper or set up a PAT.

REPO_URL="https://github.com/akmrhdy-create/WELLGUARD-XAI.git"
BRANCH="main"

echo "Initializing local repository and adding initial files..."

# Create project dir if not already in one (optional)
# The script assumes you're running it inside the project directory where files are present.

# Check for git
if ! command -v git >/dev/null 2>&1; then
  echo "git is not installed. Install git and retry." >&2
  exit 1
fi

# Initialize git if needed
if [ ! -d .git ]; then
  git init
  echo "Initialized empty Git repository."
else
  echo "Git repository already initialized."
fi

# Set or update origin
if git remote get-url origin >/dev/null 2>&1; then
  echo "Updating origin to $REPO_URL"
  git remote set-url origin "$REPO_URL"
else
  echo "Adding origin $REPO_URL"
  git remote add origin "$REPO_URL"
fi

# Ensure files exist; if they don't, create minimal ones
[ -f README.md ] || cat > README.md <<'EOF'
# WELLGUARD-XAI

WELLGUARD-XAI — initial repository for WELLGUARD XAI project.

This repository contains starter files to initialize the project so integrations (like Google AI Studio) can connect.

Quick start
- Clone or import this repo into your environment.
- Run: python main.py
EOF

[ -f .gitignore ] || cat > .gitignore <<'EOF'
# Python
__pycache__/
*.py[cod]
venv/
.env
.vscode/
.DS_Store
EOF

[ -f LICENSE ] || cat > LICENSE <<'EOF'
MIT License

Copyright (c) 2026 akmrhdy-create

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

[ -f main.py ] || cat > main.py <<'EOF'
"""WELLGUARD-XAI — initial placeholder"""

def main():
    print("WELLGUARD-XAI initial commit")


if __name__ == "__main__":
    main()
EOF

# Stage, commit, and push
git add .
# Use a default message if none exists
if git rev-parse --verify HEAD >/dev/null 2>&1; then
  echo "Existing commits detected; creating a new commit."
else
  # Create initial commit
  git commit --allow-empty -m "Initial commit: add project files" || true
fi

# If there are staged changes, commit them
if ! git diff --cached --quiet; then
  git commit -m "Initial commit: README, LICENSE, .gitignore, requirements, main.py"
else
  echo "No changes to commit."
fi

# Ensure branch name
git branch -M "$BRANCH"

# Push
echo "Pushing to remote..."
git push -u origin "$BRANCH"

echo "Done. Repository should now contain initial files on branch $BRANCH."
