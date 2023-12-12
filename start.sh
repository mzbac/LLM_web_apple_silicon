#!/bin/bash

# Define the repository and model details
REPO_URL="https://github.com/ggerganov/llama.cpp.git"
REPO_DIR="llama.cpp"
MODEL_URL="https://huggingface.co/TheBloke/Mixtral-8x7B-Instruct-v0.1-GGUF/resolve/main/mixtral-8x7b-instruct-v0.1.Q4_K_M.gguf"
MODEL_FILE="mixtral-8x7b-instruct-v0.1.Q4_K_M.gguf"

# Clone the repository if it doesn't already exist
if [ ! -d "$REPO_DIR" ]; then
  git clone "$REPO_URL"
fi

# Change directory to the cloned repository
cd "$REPO_DIR"
# Fetch the remote branches
git fetch --all

# Check if the branch exists
if git branch --list mixtral; then
  git checkout mixtral
else
  echo "Branch mixtral does not exist. Using the current branch instead."
fi

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
