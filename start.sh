#!/bin/bash

# Define the repository and model details
REPO_URL="git@github.com:ggerganov/llama.cpp.git"
REPO_DIR="llama.cpp"
MODEL_URL="https://huggingface.co/TheBloke/dolphin-2_2-yi-34b-GGUF/resolve/main/dolphin-2_2-yi-34b.Q8_0.gguf"
MODEL_FILE="dolphin-2_2-yi-34b.Q8_0.gguf"

# Clone the repository if it doesn't already exist
if [ ! -d "$REPO_DIR" ]; then
  git clone "$REPO_URL"
fi

# Change directory to the cloned repository
cd "$REPO_DIR"

# Build the project using make
# Assume make is idempotent, as it should only rebuild changed files
make

# Change directory to the models folder
mkdir -p models
cd models

# Download the model if it doesn't already exist
if [ ! -f "$MODEL_FILE" ]; then
  wget "$MODEL_URL"
fi

# Change directory back to the project root
cd ../

# Launch the server
./server -m models/"$MODEL_FILE" --host 0.0.0.0 --port 8080 -c 16000