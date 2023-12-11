#!/bin/bash

# Define paths
CHAT_UI_DIR="./chat-ui" 
ENV_FILE="$CHAT_UI_DIR/.env.local"
CONFIG_FILE="$CHAT_UI_DIR/svelte.config.js"
TEMP_FILE="$CHAT_UI_DIR/temp_config.js"

# Ensure the chat-ui directory exists
if [ ! -d "$CHAT_UI_DIR" ]; then
    echo "chat-ui directory does not exist: $CHAT_UI_DIR"
    exit 1
fi

# Modify the svelte.config.js file
awk '/base:/ {$0="			base: process.env.APP_BASE || \"/chat\","}1' "$CONFIG_FILE" > "$TEMP_FILE"

mv "$TEMP_FILE" "$CONFIG_FILE"

# Check if the sed command was successful
if [ $? -ne 0 ]; then
    echo "Failed to modify $CONFIG_FILE"
    exit 1
fi

echo "Modified svelte.config.js successfully."

# Create the .env.local file with the provided content
cat << EOF > "$ENV_FILE"
MONGODB_URL=mongodb://host.docker.internal:27017/
MODELS=\`[
    {
        "name": "ehartford/dolphin-2_2-yi-34b",
        "datasetName": "ehartford/dolphin",
        "description": "A good alternative to ChatGPT",
        "websiteUrl": "https://open-assistant.io",
        "userMessageToken": "<|im_start|>user\n",
        "assistantMessageToken": "<|im_start|>assistant\n",
        "userMessageEndToken": "<|im_end|>",
        "assistantMessageEndToken": "<|im_end|>",
        "preprompt": "<|im_start|>system\nBelow is an instruction that describes a task. Write a response that appropriately completes the request.<|im_end|>\n",
        "promptExamples": [
            {
                "title": "Write an email from bullet list",
                "prompt": "As a restaurant owner, write a professional email to the supplier to get these products every week: \n\n- Wine (x10)\n- Eggs (x24)\n- Bread (x12)"
                }, {
                "title": "Code a snake game",
                "prompt": "Code a basic snake game in python, give explanations for each step."
                }, {
                "title": "Assist in a task",
                "prompt": "How do I make a delicious lemon cheesecake?"
            }
        ],
        "parameters": {
            "temperature": 0.7,
            "top_p": 0.95,
            "repetition_penalty": 1.1,
            "top_k": 50,
            "truncate": 4048,
            "max_new_tokens": 4048,
            "stop": ["<|im_start|>user\n"]
        },
        "endpoints": [
        {
         "baseURL": "http://host.docker.internal:8080/v1",
         "type": "openai"
        }
      ]
    }
]\`
EOF

# Check if the .env.local file was created successfully
if [ $? -ne 0 ]; then
    echo "Failed to create $ENV_FILE"
    exit 1
fi

echo "Created .env.local file successfully."

