## Prerequisites
- Xcode
- Docker
- Docker Compose
- Colima container runtimes on macOS https://github.com/abiosoft/colima

## Generate Self-Signed SSL Certificate
```shell
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx-selfsigned.key -out nginx-selfsigned.crt
```

## Clone chat ui
```shell
git clone https://github.com/huggingface/chat-ui.git
```
Add dependency for chat-ui Dockerfile
```shell
RUN apt-get update && apt-get install -y libvips-dev
```

Run the configuration script to update svelte.config.js and crate a .env.local file
```shell
./config_chat_ui.sh
```

## Usage
1. Run start.sh script to launch llama.cpp server
    ```shell
    ./start.sh
    ```

2. Start UI frontend services, and open https://localhost/chat in your browser.
    ```shell
    docker-compose up --build
    ```
