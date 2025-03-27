docker build -t owui_gpu_amd64 -f Dockerfile.GPU-amd64 .
docker run -d -p 8080:8080 -p 11434:11434 -v ollama_data:/root/.ollama -v owui_data:/app/backend/data --name owui_gpu_amd64 owui_gpu_amd64
