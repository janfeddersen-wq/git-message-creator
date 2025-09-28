#!/bin/bash
# This script generates a git commit message using Cerebras AI based on staged changes.
# CEREBRAS_API_KEY=csk-........
MODEL=qwen-3-coder-480b
# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install jq to use this script."
    echo "On Ubuntu/Debian: sudo apt-get install jq"
    echo "On macOS: brew install jq"
    echo "On CentOS/RHEL: sudo yum install jq"
    exit 1
fi

# Capture the staged changes
GIT_DIFF=$(git diff --staged)

# Escape GIT_DIFF for JSON
ESCAPED_GIT_DIFF=$(echo "$GIT_DIFF" | jq -Rs .)

# Check if there are staged changes
if [ -z "$GIT_DIFF" ]; then
    echo "No staged changes found. Please stage your changes before running this script."
    exit 1
fi

# Check if CEREBRAS_API_KEY is set
if [ -z "$CEREBRAS_API_KEY" ]; then
    echo "CEREBRAS_API_KEY environment variable is not set."
    exit 1
fi

# Prepare the JSON payload
read -r -d '' JSON_PAYLOAD <<EOF
{
    "model": "$MODEL",
    "stream": false,
    "temperature": 0,
    "max_tokens": -1,
    "seed": 0,
    "top_p": 1,
    "messages": [
        {
            "role": "system",
            "content": "You are an expert at writing concise and informative git commit messages based on provided code changes. Provide only the commit message, no extra text."
        },
        {
            "role": "user",
            "content": $ESCAPED_GIT_DIFF
        }
    ]
}
EOF

# Call the Cerebras API and extract the commit message
COMMIT_MESSAGE=$(curl -s -X POST "https://api.cerebras.ai/v1/chat/completions" \
    -H "Authorization: Bearer $CEREBRAS_API_KEY" \
    -H "Content-Type: application/json" \
    -d "$JSON_PAYLOAD" | jq -r '.choices[0].message.content')

# Print the commit message
git commit -m "$COMMIT_MESSAGE"
