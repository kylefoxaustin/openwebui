Welcome to the OpenWebUI Container!

**The purpose of this container is simple: Provide a full featured OWUI container with full internet access and RAG capabilities**
As such the design criteria for the docker image was:
1) install a latest generation OWUI version
2) install a latest generation ollama server
3) open an IP pipe for a local browser to access the OWUI server
4) allow user to use 100% of the OWUI capabilities (pull new models, create new models, create knowledge (RAG) bases, create custom LLMs with knowledge base (RAG) attached

I have tried to make the image size as small as possible.  When pulled from docker.hub its ~4GB compressed.  When locally pulled it expands to ~8GB.
This is before you pull a model or add a RAG.  I am working on ways to reduce the size however ollama itself is quite large so i may not pull this size down
much more.

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
