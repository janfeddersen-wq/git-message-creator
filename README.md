# Git Commit Message Generator (gcm)

The `gcm` script is a utility that automatically stages all changes in your Git repository, generates an AI-powered commit message using Cerebras AI based on the differences, and commits those changes with the generated message.

## Features

- Automatic staging (`git add .`)
- AI-powered commit message generation using Cerebras AI
- Automatic `git commit` with the generated message
- JSON escaping of git diff to handle special characters
- `jq` dependency check

## Prerequisites

- `jq` installed on your system
- Cerebras AI API Key set as an environment variable (`CEREBRAS_API_KEY`)

## Installation

1. Move the script to `~/bin` (or a similar directory in your `PATH`) and rename it to `gcm`:
   ```bash
   mv gcm.sh ~/bin/gcm
   ```

2. Add an alias to your `~/.bashrc` or `~/.bash_profile`:
   ```bash
   alias gcm="~/bin/gcm"
   ```

3. Source your bash configuration file or open a new terminal:
   ```bash
   source ~/.bashrc
   ```

## Usage

Simply run the command in your Git repository:
```bash
gcm
```

The script will automatically stage all changes (`git add .`), generate a commit message based on the differences using Cerebras AI, and commit the changes with that message.

## Example

```bash
# Make some changes to your files
# (no need for git add, gcm does it)
gcm
