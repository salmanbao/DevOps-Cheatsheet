
---

# 🐳 **Docker Cheatsheet**

---

## 🧱 Basic Docker Commands

| Command | Description |
|--------|-------------|
| `docker --version` | Show Docker version |
| `docker info` | Display system-wide info |
| `docker system info` | Display system-wide info |
| `docker help` | Get help on Docker commands |
| `docker <command> --help` | Get help on a specific command |

---

## 📦 Working with Images

| Command | Description |
|--------|-------------|
| `docker pull <image>` | Download image from Docker Hub |
| `docker build .` | Build image from Dockerfile |
| `docker build -t <name> .` | Build image from Dockerfile |
| `docker build -f docker/app-dockerfile` | Build image from custom Dockerfile |
| `docker build --build-arg foo=bar .` | Set build-time variable |
| `docker build --pull .` | Always pull base image |
| `docker build --quiet .` | Suppress build output |
| `docker images` | List all local images |
| `docker rmi <image_id>` | Remove an image |
| `docker tag <image> <repo>:<tag>` | Tag image |
| `docker save -o <file>.tar <image>` | Save image to a .tar file |
| `docker load -i <file>.tar` | Load image from .tar file |

---

## 📦 Working with Containers

| Command | Description |
|--------|-------------|
| `docker run <image>` | Run container from image |
| `docker run -it <image>` | Run in interactive mode |
| `docker run -d <image>` | Run in detached mode |
| `docker run --rm <image>` | Remove after exit |
| `docker run --name <name> <image>` | Name the container |
| `docker ps` | List running containers |
| `docker ps -a` | List all containers |
| `docker start <container>` | Start a stopped container |
| `docker stop <container>` | Stop a running container |
| `docker kill <container>` | Kill a running container |
| `docker restart <container>` | Restart container |
| `docker rm <container>` | Remove container |
| `docker attach <container>	` | Attach to container |
| `docker exec -it <container> <cmd>` | Execute command inside container |
| `docker exec my-container ls /app` | Execute command inside container |
| `docker exec -it my-container sh` | Run shell inside container |
| `docker run <image-name> demo-command` | Run command inside container |
| `docker commit <container> new-image:latest` | Create new image from container |
| `docker rename <container> my-container` | Rename container |
| `docker logs <container>` | Show container logs |
| `docker logs -f my-container` | Follow container logs |
| `docker logs --tail 100 my-container` | Show last 100 logs |
| `docker inspect <container>` | View detailed config info |
| `docker top <container>` | Show container processes |
| `docker stats` | Live container resource usage |

---

## 📄 Copy to and From Containers

| Command | Description |
|--------|-------------|
| `docker cp my-container:/path/to/file /host/path` | Copy file from container |
| `docker cp /host/path my-container:/path/to/file` | Copy file to container |



## 📁 Volumes & Bind Mounts

| Command | Description |
|--------|-------------|
| `docker volume create <name>` | Create a volume |
| `docker volume ls` | List volumes |
| `docker volume inspect <name>` | Inspect a volume |
| `docker volume rm <name>` | Remove volume |
| `-v <volume>:/path/in/container` | Mount volume |
| `-v $(pwd):/app` | Mount bind directory |

---

## 🌐 Networking

| Command | Description |
|--------|-------------|
| `docker network ls` | List networks |
| `docker network create <name>` | Create network |
| `docker network inspect <name>` | Inspect network |
| `docker network rm <name>` | Remove network |
| `docker network connect <net> <container>` | Connect container to network |
| `docker network disconnect <net> <container>` | Disconnect container from network |
| `-p <host>:<container>` | Map ports (e.g. `-p 8080:80`) |

---

## ⚙️ Use Configuration Contexts

| Command | Description |
|--------|-------------|
| `docker context ls` | List contexts |
| `docker context create <name>` | Create context |
| `docker context use <name>` | Use context |
| `docker context rm <name>` | Remove context |

---
## 🧪 Docker Compose

| Command | Description |
|--------|-------------|
| `docker-compose up` | Start services |
| `docker-compose up -d` | Start in detached mode |
| `docker-compose down` | Stop and remove services |
| `docker-compose build` | Build services |
| `docker-compose ps` | List running services |
| `docker-compose logs` | View service logs |
| `docker-compose exec <svc> <cmd>` | Run command inside service container |

---

## 📝 Dockerfiles

| Directive | Description |
|-----------|-------------|
| `FROM` | Base image |
| `RUN` | Run a command |
| `COPY` | Copy files from host |
| `ADD` | Copy and extract files |
| `CMD` | Command to run (can be overridden) |
| `ENTRYPOINT` | Main command (hardcoded) |
| `EXPOSE` | Documented port |
| `ENV` | Set environment variables |
| `WORKDIR` | Set working directory |
| `VOLUME` | Declare mount point |
| `LABEL` | Add metadata |

---

## 🔐 Security

| Command | Description |
|--------|-------------|
| `docker scan <image>` | Scan image for vulnerabilities (if enabled) |
| `--user <uid:gid>` | Run as non-root user |
| `--read-only` | Run container filesystem as read-only |
| `--cap-drop=ALL` | Drop all Linux capabilities |

---

## 🛡️ Create SBOMs

| Command | Description |
|--------|-------------|
| `docker sbom <image>` | Create SBOM for image |
| `docker sbom <container>` | Create SBOM for container |
| `docker sbom save <image> > sbom.spdx.json` | Save SBOM to file |
| `docker sbom convert -f spdx-json -o sbom.spdx.json sbom.spdx.json` | Convert SBOM to other format |

---

## 🧹 Cleanup

| Command | Description |
|--------|-------------|
| `docker system prune` | Remove unused data |
| `docker system prune -a` | Remove all data |
| `docker system df` | Show disk usage |
| `docker image prune` | Remove dangling images |
| `docker image prune -a` | Remove all images |
| `docker container prune` | Remove stopped containers |
| `docker volume prune` | Remove unused volumes |
| `docker system prune --volumes` | Remove unused volumes |
| `docker network prune` | Remove unused networks |

---

## 🔄 Useful Flags

| Flag | Description |
|------|-------------|
| `-d` | Detached mode |
| `-it` | Interactive + TTY |
| `--rm` | Auto-remove after exit |
| `--name` | Name the container |
| `-e` | Set environment variable |
| `-v` | Volume or bind mount |
| `-p` | Port mapping |

---
