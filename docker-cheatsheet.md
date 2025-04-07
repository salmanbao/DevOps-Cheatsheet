
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
| `docker images` | List local images |
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
| `docker diff <container>` | Show container file changes |
| `docker export <container> > my-container.tar` | Export container to .tar file |
| `docker import <tar> my-container` | Import .tar file to container |

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

## 🌐 Networking Bonus

| Command | Description |
|--------|-------------|

| `docker network create -d host my-host-network` | Create a host network named `my-host-network` |
| `docker network create -d host --label environment=production my-labeled-host-network` | Create a host network with a label |
| `docker network create -d host --opt com.docker.network.host_binding_ipv4=192.168.1.100 my_host_network` | Create a host network with a custom IP address |
| `docker run --rm -d --network host --dns 8.8.8.8 --dns 8.8.4.4 --name my_container my_image` | Run a container in the host network with custom DNS servers |
| `docker run --rm -it --network host --cap-add NET_ADMIN nicolaka/netshoot tcpdump -i any` | Run a container in the host network and capture network traffic |
| `docker run --rm -d --network host --user $(id -u):$(id -g) --name my_container my_image` | Run a container in the host network with the same user ID as the host |


| `docker network create -d bridge mybridge` | Create a bridge network |
| `docker network create --driver bridge --internal my_internal_bridge` | Creating an Internal Bridge Network |
| `docker network create --driver bridge --ipv6 --subnet=2001:db8:1::/64 ipv6_enabled_bridge` | Creating a Bridge Network with IPv6 Support |
| `docker network create --driver bridge --opt com.docker.network.driver.mtu=1400 my_mtu_bridge` | Creating a Bridge Network with a Specific MTU |
| `docker network create --driver bridge --opt com.docker.network.bridge.enable_ip_masquerade=false no_masquerade_bridge` | Creating a Bridge Network without IP Masquerading |
| `docker network create --driver bridge --subnet=192.168.100.0/24 --gateway=192.168.100.1 my_custom_bridge` | Creating a Custom Bridge Network with Specific Subnet and Gateway |
| `docker network create --driver bridge --opt com.docker.network.bridge.enable_icc=false icc_disabled_bridge` | Creating a Bridge Network without Inter-Container Communication (ICC) |
| `docker network create --driver bridge --ipv6 --subnet=2001::contentReference[oaicite:66]{index=66}` | Creating a Bridge Network with IPv6-Only Support |
| `docker network create -d bridge --subnet=192.168.0/24 --gateway=192.168.0.1 --ip-range=192.168.100.128/25 --opt com.docker.network.bridge.name=custom-bridge custom_mybridge_network` | Creating a Custom Bridge Network with Specific Subnet and Gateway |


| `docker swarm init --advertise-addr <MANAGER-IP>` | Initialize a swarm |
| `docker network create -d overlay myoverlay` | Create an overlay network |
| `docker service scale my_service=5` | Scale a Service on an Overlay Network |
| `docker network create -d overlay --attachable myoverlay` | Create an attachable overlay network |
| `docker network create -d overlay --internal my_internal_overlay` | Creating an Internal Overlay Network |
| `docker network create -d overlay --opt encrypted my_secure_overlay` | Create an encrypted overlay network |
| `docker network create -d overlay --subnet=192.168.100.0/24 my_custom_subnet_overlay` | Create an overlay network with a custom subnet |
| `docker service create --name my_global_service --network my_overlay --mode global my_image` | Deploy a Global Service on an Overlay Network |
| `docker service create --name my_service --network my_overlay --publish published=8080,target=80 my_image` | Deploy a Service with Published Ports on an Overlay Network |
| `docker network create -d overlay --subnet=10.0.9.0/24 --gateway=10.0.9.1 --attachable --internal custom_overlay_network` | Creating an Overlay Network for Multi-Host Communication in a Swarm |


| `docker network create -d macvlan --subnet=237.84.2.178/24 -o parent=eth0 mymacvlan` | Create a macvlan network |
| `docker run -itd --network my_macvlan_bridge --ip 192.168.1.100 --name my_container my_image` | run a container with a specific IP address within a Macvlan network |
| `docker network create -d macvlan --subnet=192.168.50.0/24 --gateway=192.168.50.1 -o parent=eth0.50 my_macvlan_vlan50` | Create a Macvlan Network in 802.1Q Trunk Bridge Mode |
| `docker network create -d macvlan --subnet=192.168.1.0/24 --gateway=192.168.1.1 --aux-address="reserved1=192.168.1.2" -o parent=eth0 my_macvlan_exclude` | Create a Macvlan Network with Excluded Addresses |
| `docker network create -d macvlan --subnet=192.168.1.0/24 --ip-range=192.168.1.128/25 --gateway=192.168.1.1 -o parent=eth0 my_macvlan_range` | Create a Macvlan Network with IP Ranges |
| `docker network create -d macvlan --subnet=192.168.1.0/24 --gateway=192.168.1.1 --subnet=2001:db8:1::/64 --gateway=2001:db8:1::1 -o parent=eth0 my_macvlan_dualstack` | Create a Macvlan Network with Dual-Stack IPv4 and IPv6 |
| `docker network create -d macvlan --internal --subnet=192.168.1.0/24 --gateway=192.168.1.1 -o parent=eth0 my_macvlan_internal` | Create an Internal Macvlan Network |
| `docker network create -d macvlan --subnet=192.168.1.0/24 --gateway=192.168.1.1 -o parent=eth0 -o com.docker.network.driver.mtu=1400 my_macvlan_mtu` | Create a Macvlan Network with a Specific MTU |
| `docker network create -d macvlan --subnet=237.84.2.178/24 --gateway=89.207.132.170 -o parent=eth0 mymacvlan` | Create a macvlan network with gateway |
| `docker network create -d macvlan --subnet=237.84.2.178/24 --gateway=89.207.132.170 -o parent=eth0 --ip-range=237.84.2.178/24 mymacvlan` | Create a macvlan network with gateway and IP range |
| `docker network create -d macvlan --subnet=237.84.2.178/24 --gateway=89.207.132.170 -o parent=eth0 --aux-addresses=eth1=237.84.2.178 mymacvlan` | Create a macvlan network with auxiliary addresses |
| `docker network create -d macvlan --subnet=237.84.2.178/24 --gateway=89.207.132.170 -o parent=eth0 --driver-opt=macvlan_mode=bridge mymacvlan` | Create a macvlan network with driver options |
| `docker network create -d macvlan --subnet=237.84.2.178/24 --gateway=89.207.132.170 -o parent=eth0 --driver-opt=macvlan_mode=passthru mymacvlan` | Create a macvlan network with driver options |
| `docker network create -d macvlan --subnet=237.84.2.178/24 --gateway=89.207.132.170 -o parent=eth0 --driver-opt=macvlan_mode=vepa mymacvlan` | Create a macvlan network with driver options |
| `docker network create -d macvlan --subnet=237.84.2.178/24 --gateway=89.207.132.170 -o parent=eth0 --driver-opt=macvlan_mode=bridge,vepa mymacvlan` | Create a macvlan network with driver options |


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
| `docker system prune --all` | Remove all data |
| `docker image prune` | Remove dangling images |
| `docker image prune -a` | Remove all images |
| `docker container prune` | Remove stopped containers |
| `docker volume prune` | Remove unused volumes |
| `docker system prune --volumes` | Remove unused volumes |
| `docker system prune --all --volumes` | Remove all data and volumes |
| `docker system prune --all --volumes --force` | Remove all data and volumes |
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

## 🧱 Additional General Docker Commands

| Command | Description |
|--------|-------------|
| `docker version` | Show detailed version info |
| `docker login` | Log into a Docker registry |
| `docker logout` | Log out of a Docker registry |
| `docker search <term>` | Search for images on Docker Hub |

---

## 🧪 Additional Docker Compose Commands

| Command | Description |
|--------|-------------|
| `docker-compose config` | Validate and view resolved Compose config |
| `docker-compose down -v` | Also remove named volumes |
| `docker-compose stop` | Stop services without removing them |
| `docker-compose rm` | Remove stopped services |
| `docker-compose run <svc>` | Run one-off command in a new container |
| `docker-compose restart` | Restart services |
| `docker-compose pull` | Pull service images defined in Compose |
| `docker-compose push` | Push service images to registry |
| `docker-compose kill` | Force stop containers |

---

## 📦 Additional Docker Image Commands

| Command | Description |
|--------|-------------|
| `docker history <image>` | Show image layer history |
| `docker inspect <image>` | Detailed image metadata |
| `docker image ls` | Alias of `docker images` |
| `docker image rm` | Alias of `docker rmi` |

---

## ⚙️ Advanced Container Run Flags

| Flag | Description |
|------|-------------|
| `--privileged` | Give extended Linux capabilities |
| `--cap-add <cap>` | Add a Linux capability |
| `--device` | Map host devices to container |
| `--tmpfs` | Mount a tmpfs |
| `--read-only` | Make container FS read-only |
| `--ulimit` | Set container resource limits |
| `--security-opt` | Set security options |
| `--security-context` | Set security context |
| `--entrypoint` | Override entrypoint |
| `--workdir` | Set working directory |

## 🧱 Docker CLI Extensions

| Command | Description |
|--------|-------------|
| `docker extension ls` | List installed Docker Desktop extensions |
| `docker extension install <publisher>/<extension>` | Install Docker extension |
| `docker extension uninstall <name>` | Uninstall Docker extension |
| `docker extension upgrade <name>` | Upgrade Docker extension |

---

## 🔐 Credential Store Commands

| Command | Description |
|--------|-------------|
| `docker-credential-<helper> store` | Store credentials securely |
| `docker-credential-<helper> get` | Retrieve stored credentials |
| `docker-credential-<helper> erase` | Delete stored credentials |

---

## 🔄 BuildKit (docker buildx) Commands

| Command | Description |
|--------|-------------|
| `docker buildx ls` | List all builder instances |
| `docker buildx create` | Create a new builder |
| `docker buildx use <builder>` | Set active builder |
| `docker buildx build` | Advanced builds with caching, multi-arch, etc. |

---

## 📜 Checkpoint and Restore (Experimental)

| Command | Description |
|--------|-------------|
| `docker checkpoint create <container> <checkpoint>` | Create checkpoint from container |
| `docker start --checkpoint <checkpoint>` | Restore container from checkpoint |

---

## 📋 Detailed Container Resource Flags

| Flag | Description |
|------|-------------|
| `--memory` | Set memory limit |
| `--memory-swap` | Set memory + swap limit |
| `--memory-reservation` | Set soft memory limit |
| `--cpus` | Limit number of CPUs |
| `--cpu-shares` | Relative CPU share weight |
| `--cpuset-cpus` | Restrict container to CPU cores |
| `--blkio-weight` | Set block IO weight |

---

## 🧠 Docker Events and System Monitoring

| Command | Description |
|--------|-------------|
| `docker events` | Stream real-time Docker events |
| `docker inspect --format '{{ .State.Running }}'` | Query state with Go templating |
| `docker system events` | Low-level system-wide events |
| `docker container stats --no-stream` | Instant snapshot of container stats |

---

## 🌐 Miscellaneous Commands

| Command | Description |
|--------|-------------|
| `docker context export` | Export Docker context |
| `docker context import` | Import a Docker context |
| `docker image inspect <image>` | Detailed image info |
| `docker trust <command>` | Manage Docker Content Trust |
| `docker config create` | Create a Swarm config |
| `docker config ls` | List Swarm configs |
| `docker service update` | Update a running service in Swarm |


---

## 🔍 General Management with Formatting

| Command | Description |
|--------|-------------|
| `docker info --format '{{.ServerVersion}}'` | Display Docker server version using Go templates |
| `docker system info --format '{{.OSType}}'` | Display OS type of Docker host in formatted output |

---

## ⚙️ Additional Runtime Flags

| Flag | Description |
|------|-------------|
| `--log-driver` | Specify logging backend (`json-file`, `syslog`, etc.) |
| `--log-opt` | Set options for the logging driver (e.g., `max-size`, `max-file`) |
| `--restart` | Restart policy for container (`no`, `on-failure`, `unless-stopped`, `always`) |
| `--env-file` | Load environment variables from a file |
| `--add-host` | Add a custom host-to-IP mapping |
| `--shm-size` | Set size of `/dev/shm` shared memory (e.g. for PostgreSQL) |

---

## 🧪 Docker Compose Advanced Commands

| Command | Description |
|--------|-------------|
| `docker-compose config --services` | List all service names in config |
| `docker-compose config --volumes` | List all named volumes in config |
| `docker-compose port <svc> <port>` | Print mapped host port for a service container port |
| `docker-compose images` | List images used in services (may require plugin) |
| `docker-compose events` | Stream container and Compose events (plugin) |

---

## 🧠 Container Lifecycle & Meta Commands

| Command | Description |
|--------|-------------|
| `docker container rename` | Rename an existing container |
| `docker container update` | Update container resource limits live |
| `docker container wait` | Wait until a container exits |
| `docker container pause` | Pause container processes |
| `docker container unpause` | Resume paused container processes |

---

## 🧱 Docker Context Extras

| Command | Description |
|--------|-------------|
| `docker context inspect <name>` | Show detailed Docker context info |

---

## 🧰 Developer / Tooling Commands

| Command | Description |
|--------|-------------|
| `docker events --since '10m'` | Show Docker events from last 10 minutes |
| `docker inspect <obj> --format '{{json .}}'` | Inspect object and return raw JSON output |

---

## 🧼 Builder Prune (Cleanup)

| Command | Description |
|--------|-------------|
| `docker builder prune` | Remove unused BuildKit builder cache |


---

## 🧪 Experimental & Edge Features (Optional)

| Command | Description |
|--------|-------------|
| `docker system dial-stdin` | Used internally for Docker CLI communication |
| `docker scan --dependency-tree` | Show dependency tree for image scan results |
| `docker sbom diff` | Compare SBOMs between two images (if supported) |
| `docker debug` | Launch Docker Desktop with debugging mode |
| `docker container exec --detach-keys` | Override the default detach key sequence |
| `docker logs --timestamps` | Include timestamps in container logs output |

---

## 🧩 Registry & Signing Commands

| Command | Description |
|--------|-------------|
| `docker trust sign <image>` | Sign image using Docker Content Trust |
| `docker trust inspect <image>` | View trusted signatures for image |
| `docker trust revoke <image>` | Revoke trust for an image tag |

---

## 🛠️ Internal Filtering & Formatting Examples

| Command | Description |
|--------|-------------|
| `docker image ls --format '{{.Repository}}:{{.Tag}}'` | Custom output formatting |
| `docker container ls --filter "status=exited"` | Filter containers by status |
| `docker network ls --filter driver=bridge` | List networks with specific driver |
| `docker stats --format "{{.Name}}: {{.MemUsage}}"` | Custom memory usage stats |

---

## 📦 OCI-Oriented and Advanced Build Features

| Command | Description |
|--------|-------------|
| `docker buildx bake` | Advanced build workflows using bake files |
| `docker image save --format oci` | Save image in OCI-compliant format |
| `docker image import --format oci` | Import OCI image tarball |

---

## 🧩 Compose Bonus: Override & Profiles

| Command | Description |
|--------|-------------|
| `docker-compose -f base.yml -f override.yml up` | Compose layering with overrides |
| `docker-compose --profile debug up` | Enable optional profile-based services |
