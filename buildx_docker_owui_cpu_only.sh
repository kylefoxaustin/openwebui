# Create a new builder instance
docker buildx create --name multiarch --use

# Bootstrap the builder
docker buildx inspect --bootstrap

docker buildx build --platform linux/amd64,linux/arm64 -t kylefoxaustin/owui_llm_rag_ready:multiarch -f Dockerfile.cpu-only .
