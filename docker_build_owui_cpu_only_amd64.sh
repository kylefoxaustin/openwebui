docker build -t owui_cpu_only_amd64 -f Dockerfile.cpu-only
docker run -d -p 8080:8080 -p 11434:11434 -v ollama_data:/root/.ollama -v owui_data:/app/backend/data --name owui_cpu_only owui_cpu_only_amd64
