# OpenWebUI with GPU-Accelerated Ollama

This repository provides Docker configurations to run [OpenWebUI](https://github.com/open-webui/open-webui) with [Ollama](https://github.com/ollama/ollama), optionally accelerated by NVIDIA GPUs for faster inference on local large language models.

## Overview

This setup provides:
- Web interface for interacting with large language models (LLMs)
- GPU acceleration for faster model inference (when available)
- Persistent storage for models and conversation history
- Containerized environment for easy deployment and management

## Quick Start (Recommended)

The default configuration automatically detects if you have an NVIDIA GPU with the required drivers and uses it. Otherwise, it falls back to CPU.

```bash
# Clone the repository
git clone https://github.com/yourusername/openwebui-gpu.git
cd openwebui-gpu

# Start the containers
docker compose up -d

# Access the web interface
# http://localhost:8080
```

That's it! For most users, this is all you need to do.

## Detailed Setup Instructions

### System Requirements

#### For All Systems
- Docker Engine (version 20.10.0 or higher)
- Docker Compose (version 2.0.0 or higher)
- 8GB+ RAM recommended (16GB+ for larger models)
- 20GB+ free disk space for models

#### For GPU Acceleration (Optional)
- NVIDIA GPU with CUDA support
- NVIDIA Driver (version 470.xx or higher)
- NVIDIA Container Toolkit (nvidia-docker2)

### Installation Options

This repository offers three ways to deploy:

1. **Quick Start** (`docker-compose.yml`) - Uses official images with automatic GPU detection
2. **CPU-Only** (`docker-compose-cpu.yml`) - Explicitly uses CPU-only configuration
3. **Custom Build** - Builds containers from Dockerfiles for CPU (`Dockerfile.cpu`) or GPU (`Dockerfile.gpu`)

### Setup for GPU Acceleration

If you have an NVIDIA GPU and want to use it for acceleration, you'll need to install the NVIDIA Container Toolkit:

```bash
# Set up the package repository and GPG key
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

# Create directory for keyrings if it doesn't exist
sudo mkdir -p /etc/apt/keyrings

# Download and install the GPG key
curl -fsSL https://nvidia.github.io/nvidia-docker/gpgkey | sudo gpg --dearmor -o /etc/apt/keyrings/nvidia-docker.gpg

# Add the repository
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sed 's#deb https://#deb [signed-by=/etc/apt/keyrings/nvidia-docker.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list

# Update package listings
sudo apt-get update

# Install nvidia-container-toolkit
sudo apt-get install -y nvidia-container-toolkit

# Configure the runtime
sudo nvidia-ctk runtime configure --runtime=docker

# Restart Docker to apply changes
sudo systemctl restart docker
```

Verify the installation:

```bash
sudo docker run --rm --gpus all nvidia/cuda:11.8.0-base-ubuntu22.04 nvidia-smi
```

If the above command shows your GPU information, the toolkit is properly set up.

### Deployment Options

#### 1. Using Official Images (Recommended)

This approach pulls pre-built images and is the quickest way to get started.

**Default configuration** (Auto-detects GPU):
```bash
docker compose up -d
```

**CPU-only configuration**:
```bash
docker compose -f docker-compose-cpu.yml up -d
```

#### 2. Custom Build

This approach builds the containers from Dockerfiles, giving you more control but taking longer.

**For CPU-only systems**:
```bash
docker compose -f docker-compose-custom-cpu.yml up -d --build
```

**For systems with NVIDIA GPU**:
```bash
docker compose -f docker-compose-custom-gpu.yml up -d --build
```

## Usage

### Accessing the Interface

Once the containers are running, access the OpenWebUI interface at:

```
http://localhost:8080
```

### Downloading and Running Models

1. Open the OpenWebUI interface in your browser
2. Go to the "Models" section
3. Choose a model from the available options (like Llama 3, Mistral, etc.)
4. Click "Download" to download the model
5. Once downloaded, start a conversation with the model

### Verifying GPU Acceleration

To verify that GPU acceleration is working:

1. Start a conversation with a model
2. While the model is generating a response, run this command:

```bash
nvidia-smi
```

You should see the Ollama process in the list, confirming GPU usage.

For a more dynamic view, you can run:

```bash
watch -n 1 nvidia-smi
```

This will update the display every second, allowing you to observe GPU utilization in real-time while you interact with the model.

## Configuration

### Port Configuration

By default, the services use the following ports:

- `8080`: OpenWebUI interface
- `11436`: Ollama API (changed from the default 11434 to avoid conflicts with locally installed Ollama)

If you need to change these ports, modify the appropriate docker-compose.yml file.

### Persistent Storage

The configuration includes persistent volumes for:

- `open-webui-data`: Stores conversation history and OpenWebUI configurations
- `ollama-data`: Stores downloaded models and Ollama configurations

These volumes persist even when the containers are stopped or removed.

## Troubleshooting

### Check Container Status

```bash
docker ps | grep -E 'open-webui|ollama'
```

### View Container Logs

```bash
# OpenWebUI logs
docker logs -f open-webui

# Ollama logs
docker logs -f ollama
```

### Common Issues

#### Port Conflicts

If you see an error like "port is already allocated", it means another service is using the same port. Edit the docker-compose.yml file to use a different port.

#### GPU Not Being Used

If the GPU is not being used:

1. Verify NVIDIA Container Toolkit is installed correctly
2. Ensure your GPU is supported and drivers are installed
3. Check Ollama logs for any error messages

#### Models Running Slowly

- If using GPU, check that your GPU is properly detected with `nvidia-smi`
- Ensure you have enough system memory (16GB+ recommended for larger models)
- Try a smaller model that better fits your hardware capabilities

#### Cannot Access Web Interface

- Check if the containers are running with `docker ps`
- Verify port 8080 is not being used by another application
- Check container logs for any startup errors

## Additional Commands

### Stopping the Containers

```bash
docker compose down
```

### Updating the Containers

```bash
docker compose pull
docker compose up -d
```

### Removing Volumes (Caution: This will delete all models and data)

```bash
docker compose down -v
```

## Compatibility

### Hardware Support

This project has been tested with:

- **CPUs**: Intel and AMD x86_64 processors
- **GPUs**: NVIDIA Quadro RTX 8000, RTX series, and Tesla series

### Operating Systems

- Ubuntu 22.04 LTS (primary test platform)
- Other Linux distributions with Docker support
- Windows with WSL2 and Docker Desktop
- macOS with Docker Desktop

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [OpenWebUI](https://github.com/open-webui/open-webui) for the web interface
- [Ollama](https://github.com/ollama/ollama) for the model inference server
- [NVIDIA](https://github.com/NVIDIA/nvidia-docker) for the Container Toolkit

- 
