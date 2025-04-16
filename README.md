# OpenWebUI with GPU-Accelerated Ollama

This repository contains Docker Compose configuration to run [OpenWebUI](https://github.com/open-webui/open-webui) with GPU-accelerated [Ollama](https://github.com/ollama/ollama) for faster inference on local large language models.

## Overview

This setup provides:
- Web interface for interacting with large language models (LLMs)
- GPU acceleration for faster model inference
- Persistent storage for models and conversation history
- Containerized environment for easy deployment and management

## Prerequisites

### System Requirements

- Ubuntu 22.04 or another Linux distribution with Docker support
- Docker Engine (version 20.10.0 or higher)
- Docker Compose (version 2.0.0 or higher)
- NVIDIA GPU (optional, for GPU acceleration)

### For GPU Acceleration

- NVIDIA GPU with CUDA support
- NVIDIA Driver (version 470.xx or higher)
- NVIDIA Container Toolkit (nvidia-docker2)

### Setting up NVIDIA Container Toolkit (for GPU acceleration)

If you have an NVIDIA GPU and want to use it for acceleration, you'll need to install the NVIDIA Container Toolkit:

```bash
# Set up the package repository and GPG key using newer method
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

# Create directory for keyrings if it doesn't exist
sudo mkdir -p /etc/apt/keyrings

# Download and install the GPG key to the keyrings directory
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

## Installation

### Step 1: Clone the repository

```bash
git clone https://github.com/yourusername/openwebui-gpu.git
cd openwebui-gpu
```

This repository provides two deployment options:

1. **Using official images** - Quick and easy setup using pre-built images
2. **Custom build** - Building your own containers from the provided Dockerfiles

### Step 2: Choose the right configuration

This repository is designed to be flexible, supporting both GPU-accelerated and CPU-only deployments:

#### Option 1: Using docker-compose.yml (Recommended)

The main `docker-compose.yml` file is designed to be universal:
- On systems with NVIDIA GPU + Container Toolkit: It will automatically use GPU acceleration
- On systems without GPU or Container Toolkit: It will automatically fall back to CPU-only operation

This means most users can simply use the default configuration without modifications.

#### Option 2: Custom Build with Dockerfile

For users who want to build a custom container:
- `Dockerfile.cpu` - Creates a CPU-only version (works on all systems)
- `Dockerfile.gpu` - Creates a GPU-enabled version (requires NVIDIA GPU)

To build using the Dockerfile approach:
```bash
# For CPU-only build
docker compose -f docker-compose-custom-cpu.yml up -d --build

# For GPU-enabled build
docker compose -f docker-compose-custom-gpu.yml up -d --build
```

### Step 3: Start the containers

#### Option 1: Using official images (recommended for most users)

```bash
# Start with default configuration (automatically detects GPU if available)
docker compose up -d
```

#### Option 2: Custom build

For CPU-only systems:
```bash
docker compose -f docker-compose-custom-cpu.yml up -d --build
```

For systems with NVIDIA GPU:
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

## Configuration

### Port Configuration

By default, the services use the following ports:

- `8080`: OpenWebUI interface
- `11436`: Ollama API (changed from the default 11434 to avoid conflicts with locally installed Ollama)

If you need to change these ports, modify the `docker-compose.yml` file.

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

If you see an error like "port is already allocated", it means another service is using the same port. Edit the `docker-compose.yml` file to use a different port.

#### GPU Not Being Used

If the GPU is not being used:

1. Verify NVIDIA Container Toolkit is installed correctly
2. Ensure your GPU is supported and drivers are installed
3. Check Ollama logs for any error messages

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

### Deployment Options

This repository provides two deployment approaches with different benefits:

1. **Official Images** (`docker-compose.yml`):
   - Quick to deploy
   - Automatically uses GPU if available
   - Falls back to CPU if no GPU is detected
   - Easier to update

2. **Custom Builds** (`Dockerfile.cpu` and `Dockerfile.gpu`):
   - More control over the build process
   - Can be optimized for specific hardware
   - Suitable for specialized environments
   - Allows for customization of the builds

### Tested Hardware

#### GPUs
- NVIDIA GeForce RTX Series
- NVIDIA Quadro RTX Series (specifically tested with Quadro RTX 8000)
- NVIDIA Tesla Series

#### CPU Architectures
- AMD64/x86_64 (Intel/AMD processors)

### CPU-Only Mode

If you don't have a compatible GPU or if you choose the CPU-only configuration, the setup will still work but model inference will be slower. This is ideal for:
- Development environments
- Systems without NVIDIA GPUs
- Testing before deploying to GPU-enabled systems

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [OpenWebUI](https://github.com/open-webui/open-webui) for the web interface
- [Ollama](https://github.com/ollama/ollama) for the model inference server
- [NVIDIA](https://github.com/NVIDIA/nvidia-docker) for the Container Toolkit





Welcome to the OpenWebUI Container!

**The purpose of this container set is simple: Provide a full featured OWUI container with full internet access and RAG capabilities**

As such the design criteria for the docker image was:
1) install a latest generation OWUI version
2) install a latest generation ollama server
3) open an IP pipe for a local browser to access the OWUI server
4) allow user to use 100% of the OWUI capabilities (pull new models, create new models, create knowledge (RAG) bases, create custom LLMs with knowledge base (RAG) attached
5) Create two container types (tags) CPU-only and GPU-only:  This applies to ollama and where it runs its models.  Nvidia is the GPU (have not tested on AMD GPUs) 
I have tried to make the image size as small as possible.  When pulled from docker.hub its ~4GB compressed.  When locally pulled it expands to ~8GB.
This is before you pull a model or add a RAG.  I am working on ways to reduce the size however ollama itself is quite large so i may not pull this size down
much more.

**Super quick start instructions:**
## Quick Start (Using Docker Compose)

1. Make sure you have Docker and Docker Compose installed
2. Clone this repository
3. place docker-compose.yml.cpu_only and Dockerfile.cpu_only into a separate directory
4. place docker-compose.yml.gpu_only and Dockerfile.gpu_only into a different separate directory
5. rename docker-compose.yml.cpu-only or .gpu-only to simply docker-compose.yml
6. navigate to the directory you want to build from (with .cpu_only or .gpu_only Dockerfiles)
7. Run `docker-compose up -d` --> this will build the image and run the container
8. Access the web interface at http://localhost:8080

## Alternative: Building with Docker directly

If you prefer not to use Docker Compose:

```bash
# Build the image
docker build -t owui-cpu-only -f Dockerfile.cpu_only .  # or use Dockerfile.gpu_only 

# Run the container
docker run -d -p 8080:8080 -p 11434:11434 \
  -v ollama_data:/root/.ollama \
  -v openwebui_data:/app/backend/data \
  owui-cpu-only

Components

Ollama: LLM serving platform
OpenWebUI: Web interface for interacting with Ollama

Data Persistence
Data is stored in Docker volumes:

ollama_data: Stores downloaded models
openwebui_data: Stores user data and settings

**More detailed instructions** 
**I chose to use docker-compose.yml to coordinate the build.  Therefore there is:**
1) a "docker-compose.yml.cpu_only" file.
2) a "docker-compose.yml.gpu_only" file.
3) Both build for multi-arch (amd64 and arm64) -- but you must docker-compose up on the target platform (e.g. arm64 must be run on an ARM64 processor)
4) a series of Dockerfiles to build the appropriate image
      - "Dockerfile.cpu_only" - this version ONLY runs on a cpu (GPU is disabled)
      - "Dockerfile.gpu_only" - this version runs on EITHER a GPU (nvidia) or CPU


**Prerequisites**
- docker installed for Command line operation (have not tested with Docker desktop)
- docker compose is installed
- docker buildx is installed
- ubuntu 22.04 OS (i have not tested on any other version but it should work)
  
**When building you would create a directory structure such as this:**
~/Documents/docker_build/cpu_only
             - docker-compose.yml **(renamed from: docker-compose.yml.cpu_only)**
             - Dockerfile.cpu_only
~/Documents/docker_build/gpu_only
             - docker-compose.yml **(renamed from: docker-compose.yml.gpu_only)**
             - Dockerfile.gpu_only

Go into each directory separately (e.g. cd ~/Documents/docker_build/cpu_only)
and run the command:  
               docker-compose up -d
               this will initiate the build process and run the container

once complete the build process will report that the container is running.
**go to your local web browser and navigate to:  http://localhost:8080**

**From there OWUI will be up and you can use it however you wish.**
