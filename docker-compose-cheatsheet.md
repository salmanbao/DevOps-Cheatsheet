### 🧩 Cheatsheet Structure (Planned Parts)

| Part | Topic |
|------|-------|
| **Part 1** | Basics: `version`, `services`, `networks`, `volumes` |
| **Part 2** | Advanced service options: `build`, `command`, `depends_on`, `restart`, `profiles` |
| **Part 3** | Environment: `env_file`, `environment`, interpolation |
| **Part 4** | Shared resources: `secrets`, `configs`, `x-extensions`, `anchors` |
| **Part 5** | Compose enhancements: `profiles`, `fragments`, `include`, `merge`, `develop`, `deploy` |
| **Part 6** | Real-world patterns (based on awesome-compose and Gitpod examples) |
| **Part 7** | Tips, CLI integration, `.env`, Makefiles, and best practices |

---

## 🧾 Docker Compose Deep Cheatsheet — Part 1: Basics

```markdown
# 🐳 Docker Compose Deep Cheatsheet (Part 1: Basics)

> Based on official Docker docs and real-world examples.

---

## 🔹 version

```yaml
version: "3.9"
```

- Specifies the version of the Compose file format.
- Recommended: Always use the **latest stable version** for compatibility.
- Latest: [3.9+](https://docs.docker.com/compose/compose-file/compose-versioning/)

---

## 🔹 services

Defines containerized app components.

```yaml
services:
  app:
    image: my-app
    ports:
      - "3000:3000"
  redis:
    image: redis
```

Each service maps to a container with its own config.

---

## 🔹 volumes

Used to persist data and share between services.

### Named Volume

```yaml
services:
  db:
    volumes:
      - db-data:/var/lib/postgresql/data

volumes:
  db-data:
```

### Bind Mount

```yaml
services:
  app:
    volumes:
      - ./src:/app
```

📌 Reference:  
- https://docs.docker.com/reference/compose-file/volumes/

---

## 🔹 networks

Allow services to communicate with each other internally.

```yaml
services:
  app:
    networks:
      - frontend
  db:
    networks:
      - backend

networks:
  frontend:
  backend:
```

Options:
```yaml
networks:
  frontend:
    driver: bridge
```

📌 Reference:  
- https://docs.docker.com/reference/compose-file/networks/

---

## 🔹 Simple Example

```yaml
version: "3.9"

services:
  web:
    image: nginx
    ports:
      - "80:80"
    networks:
      - frontend

  app:
    build: .
    volumes:
      - .:/app
    networks:
      - frontend
      - backend

  db:
    image: postgres
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - backend

networks:
  frontend:
  backend:

volumes:
  db-data:
```

---

## 🔹 Compose CLI Basics

```bash
docker-compose up            # Start all services
docker-compose down          # Stop and remove services + network
docker-compose build         # Build services from Dockerfile
docker-compose logs -f       # Tail logs
docker-compose ps            # Show container statuses
docker-compose config        # Validate final YAML output
```

---

# 🐳 Docker Compose Deep Cheatsheet (Part 2: Advanced Service Options)

> Dive deeper into service customization: builds, commands, dependencies, restart policies, and more.

```yaml
version: "3.9"
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
      target: runtime
      args:
        NODE_VERSION: 18
```

---

## 🔧 `build`

Tells Compose how to build the Docker image from source.

```yaml
build:
  context: ./app
  dockerfile: Dockerfile.custom
  target: dev
  args:
    NODE_ENV: development
```

### Options:
| Key         | Description |
|-------------|-------------|
| `context`   | Path to the build directory |
| `dockerfile` | Name of Dockerfile (default: `Dockerfile`) |
| `target`    | Build stage in a multi-stage Dockerfile |
| `args`      | Build-time arguments (use `ARG` in Dockerfile) |

📘 Docs: [build reference](https://docs.docker.com/reference/compose-file/build/)

---

## 🏁 `command` vs `entrypoint`

### `command`

Overrides the default `CMD` in the Dockerfile.

```yaml
command: ["npm", "start"]
```

### `entrypoint`

Overrides the Dockerfile `ENTRYPOINT`.

```yaml
entrypoint: ["node", "dist/server.js"]
```

### Combined Example

```yaml
entrypoint: ["node"]
command: ["dist/server.js"]
```

📘 Tip: Use `command` to customize behavior per environment.

---

## 🔗 `depends_on`

Specifies the start order of services.

```yaml
services:
  web:
    build: .
    depends_on:
      - db
      - redis
```

> **Note**: It **does not wait for dependencies to be “ready”** (just started). Use healthchecks or wait-for-it scripts for that.

📘 Docs: [depends_on reference](https://docs.docker.com/compose/startup-order/)

---

## 🔁 `restart`

Controls the container restart policy.

```yaml
restart: always
```

### Options:
| Value           | Description |
|----------------|-------------|
| `no` (default) | Never restart |
| `always`       | Always restart |
| `on-failure`   | Restart only on failure |
| `unless-stopped` | Restart unless explicitly stopped |

---

## 🧬 `profiles`

Define named groups of services that only start when explicitly enabled.

```yaml
services:
  debug-tool:
    image: busybox
    command: sleep infinity
    profiles:
      - debug
```

### Run with profile:

```bash
docker-compose --profile debug up
```

> Profiles help reduce resource use by running only what you need per environment.

📘 Docs: [profiles](https://docs.docker.com/reference/compose-file/profiles/)

---

## 🎯 `container_name`

Optional: sets a custom container name (avoids autogenerated names).

```yaml
container_name: my-app-container
```

> ⚠️ Not recommended for large projects or scaled services—can cause name conflicts.

---

## 🧠 Full Example with All Advanced Options

```yaml
services:
  api:
    build:
      context: .
      dockerfile: Dockerfile
      target: prod
      args:
        NODE_VERSION: 18
    entrypoint: ["node"]
    command: ["dist/server.js"]
    container_name: node-api
    depends_on:
      - db
    restart: unless-stopped
    profiles:
      - prod
```

---

# 🐳 Docker Compose Deep Cheatsheet (Part 3: Environment, Secrets & Interpolation)

> How to manage variables, sensitive data, and reusable configurations across environments.

---

## 🔹 `environment`

Set environment variables directly in your Compose file.

```yaml
services:
  app:
    image: node:18
    environment:
      NODE_ENV: production
      PORT: 3000
      DB_HOST: db
```

Can also be written in shorthand:

```yaml
environment:
  - NODE_ENV=production
  - PORT=3000
```

> 🧠 Use long form for better readability and support for complex values.

---

## 🔹 `env_file`

Load environment variables from one or more files.

```yaml
services:
  app:
    env_file:
      - .env
      - .env.production
```

- Values in `env_file` are treated as environment variables during container creation.
- You can combine `env_file` with `environment`, and the `environment` block takes precedence.

**`.env.production`**
```env
NODE_ENV=production
PORT=8080
```

📘 Docs: [env_file](https://docs.docker.com/compose/environment-variables/env-file/)

---

## 🧬 Interpolation (Variable Substitution)

You can use `${VARIABLE}` syntax to substitute environment variables into your `docker-compose.yaml`.

### Example

```yaml
services:
  app:
    image: "node:${NODE_VERSION:-18}"  # fallback if undefined
    environment:
      - DATABASE_URL=${DATABASE_URL}
```

### Rules

| Syntax | Meaning |
|--------|---------|
| `${VAR}` | Uses `VAR`, errors if not defined |
| `${VAR:-default}` | Uses `VAR`, fallback to `default` if not defined |
| `${VAR-default}` | Same as above, but doesn't throw an error if `VAR` is defined but empty |
| `${VAR:?error}` | Fails and shows error message if `VAR` is not defined |

📘 Docs: [interpolation](https://docs.docker.com/reference/compose-file/interpolation/)

---

## 🔐 `secrets`

Used to securely pass sensitive data like API keys, tokens, passwords.

### Define secrets (file-based)

```yaml
secrets:
  db_password:
    file: ./secrets/db_password.txt
```

### Use secrets in services

```yaml
services:
  db:
    image: postgres
    secrets:
      - db_password
```

In the container, the secret will be available at `/run/secrets/db_password`.

📘 Docs: [secrets](https://docs.docker.com/reference/compose-file/secrets/)

---

## 🧾 Difference: env_file vs secrets

| Feature        | `env_file`          | `secrets`               |
|----------------|---------------------|--------------------------|
| Use case       | Config/env variables | Sensitive credentials    |
| File format    | `.env` (key=value)   | Plaintext value only     |
| Where available | As env vars          | As mounted files         |
| Secure in Swarm | ❌                  | ✅ yes (Swarm-only feature) |

---

## 🧠 Best Practices

- Use `.env` for shared project-level variables (e.g. ports, env, image tags).
- Use `env_file` to manage environment-specific values per Compose file.
- Use `secrets` for passwords, tokens, or credentials.
- Use `${}` for templating between files and `.env`.

---

## 🧪 Example Setup

**.env**
```env
NODE_ENV=development
PORT=3000
DATABASE_URL=postgres://user:pass@db:5432/mydb
```

**docker-compose.yaml**
```yaml
version: "3.9"

services:
  api:
    image: "node:${NODE_VERSION:-18}"
    ports:
      - "${PORT:-3000}:3000"
    environment:
      - NODE_ENV=${NODE_ENV}
      - DATABASE_URL=${DATABASE_URL}
    env_file:
      - .env
    secrets:
      - db_password

secrets:
  db_password:
    file: ./secrets/db_password.txt
```

---


# 🐳 Docker Compose Deep Cheatsheet (Part 4: Reuse, Configs & Fragments)

> Reuse blocks with YAML magic, manage configs declaratively, and write modular Compose files.

---

## 🔗 YAML Anchors, Aliases, and Merge Keys

YAML supports **anchors** (`&`), **aliases** (`*`), and **merge keys** (`<<`) to reuse configuration blocks.

---

### 🔹 Define a Block with `&` (Anchor)

```yaml
x-common-settings: &common-settings
  restart: unless-stopped
  environment:
    TZ: UTC
    LANG: C.UTF-8
```

---

### 🔹 Reuse with `*` and Merge with `<<`

```yaml
services:
  app:
    image: my-app
    <<: *common-settings
    ports:
      - "3000:3000"
```

- `*common-settings` references the anchor.
- `<<: *anchor` merges the referenced block.

📘 Docs: [YAML merge and anchors](https://docs.docker.com/reference/compose-file/fragments/)

---

### 🧠 Overriding Merged Values

```yaml
services:
  app:
    <<: *common-settings
    environment:
      TZ: Europe/Paris   # overrides the value from anchor
```

> Merged blocks can be overridden or extended as needed.

---

## 📦 `configs`: Externalize Configuration Files

Compose supports mounting **configs** (like JSON or YAML files) into containers in a clean and controlled way (great for `.env`, app settings, etc.).

---

### 🔹 Define Configs

```yaml
configs:
  app_config:
    file: ./config/app.json
```

---

### 🔹 Use in a Service

```yaml
services:
  app:
    image: my-app
    configs:
      - source: app_config
        target: /app/config/app.json
```

📌 The `target` is where the config file appears inside the container.

> 🧠 Unlike volumes, `configs` are read-only and designed for structured, static files (not secrets or logs).

📘 Docs: [Compose Configs](https://docs.docker.com/reference/compose-file/configs/)

---

## 🔁 `x-` Extensions (Custom Top-Level Blocks)

Use custom `x-` prefixed keys to define reusable values or blocks.

```yaml
x-build-args: &build-args
  args:
    NODE_ENV: production
    APP_VERSION: 1.0.0

services:
  web:
    build:
      context: .
      <<: *build-args
```

> Docker Compose ignores all `x-*` blocks—they're just for reuse.

---

## 🔍 YAML Fragments

Use anchors + `x-extensions` to define and reuse **larger fragments**, like whole build or deployment blocks.

```yaml
x-deploy-config: &deploy-config
  deploy:
    replicas: 3
    resources:
      limits:
        cpus: '0.5'
        memory: 512M

services:
  api:
    image: api
    <<: *deploy-config
```

---

## 🧠 Real-world Use Case

```yaml
version: "3.9"

x-default-env: &default-env
  environment:
    NODE_ENV: production
    LOG_LEVEL: info

x-default-ports: &default-ports
  ports:
    - "8080:8080"

services:
  frontend:
    image: frontend
    <<: [*default-env, *default-ports]

  backend:
    image: backend
    <<: *default-env
    ports:
      - "5000:5000"
```

---


# 🐳 Docker Compose Deep Cheatsheet (Part 5: Modular Compose – Include, Merge, Develop & Profiles)

> Modularize your Compose stack using includes, profiles, overrides, and more.

---

## 🔗 `include`: Modularizing Compose Files (v3.10+ with Docker Compose CLI v2)

> **Note**: This is part of the newer Compose Specification. Works with **Compose CLI v2.20+**.

```yaml
include:
  - ./base.yml
  - ./dev.override.yml
```

- Includes external Compose files into the current file.
- Allows breaking complex stacks into multiple small files.
- Can be used with **profiles** and **fragments**.

📘 Docs: [Compose Include](https://docs.docker.com/reference/compose-file/include/)

---

## 🔁 `merge` Strategies (when using multiple Compose files)

Docker Compose **merges services** by:
- **Replacing scalar values** (like `image`, `command`)
- **Merging mappings** (like `environment`, `labels`)
- **Appending lists** (like `volumes`, `ports`)

### 📌 CLI Order Matters

```bash
docker-compose -f docker-compose.yml -f docker-compose.override.yml up
```

- Values in the **second file override** or extend the first.
- This allows **base + environment-specific override** patterns.

📘 Docs: [Merge behavior](https://docs.docker.com/reference/compose-file/merge/)

---

## 🎯 Profiles (Revisited)

Let you **conditionally start** services or blocks.

### Define Profiles

```yaml
services:
  debug:
    image: alpine
    command: sleep infinity
    profiles:
      - debug
```

### Enable Profile at Runtime

```bash
docker-compose --profile debug up
```

- Profiles **do not start** by default.
- Great for toggling monitoring, debug tools, migrations, etc.

---

## 🧪 `develop`: Development-Specific Settings

New feature in Compose Spec (experimental).

```yaml
develop:
  watch:
    - path: ./src
      action: rebuild  # or sync, none
```

- Enables hot reload-like behavior (useful for Node.js, React, etc.)
- Can also define **syncs** or **rebuild** triggers

> ⚠️ Currently supported only by Compose implementations like [Docker Compose v2](https://docs.docker.com/compose/cli-command/)

📘 Docs: [Compose Develop](https://docs.docker.com/reference/compose-file/develop/)

---

## 🧩 Extension Fields (`x-*`)

Let you define reusable fields outside the Compose spec that won’t be parsed by Docker.

```yaml
x-default-deploy: &deploy-settings
  deploy:
    replicas: 2
    restart_policy:
      condition: on-failure

services:
  api:
    image: my-api
    <<: *deploy-settings
```

- Combine with `<<` to inject values into services.
- Use for `deploy`, `build`, `env`, `healthcheck`, etc.

📘 Docs: [Compose Extensions](https://docs.docker.com/reference/compose-file/extension/)

---

## 🔧 Example: Multi-Environment Setup

**docker-compose.yml** (Base)
```yaml
version: "3.9"

services:
  app:
    image: my-app
    ports:
      - "3000:3000"
```

**docker-compose.prod.yml**
```yaml
services:
  app:
    image: my-app:prod
    environment:
      NODE_ENV: production
```

**docker-compose.dev.yml**
```yaml
services:
  app:
    build:
      context: .
    develop:
      watch:
        - path: ./src
          action: sync
    environment:
      NODE_ENV: development
```

---

## 🔥 Compose CLI with Overrides

```bash
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up
```

or for prod:

```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml --env-file .env.prod up -d
```

---

# 🐳 Docker Compose Deep Cheatsheet (Part 6: Real-World Patterns & Templates)

> Practical, production-inspired examples for fullstack, microservices, and dev containers.

---

## ⚙️ Pattern 1: Node.js + PostgreSQL (Fullstack App)

```yaml
version: "3.9"

services:
  api:
    build:
      context: .
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgres://user:password@db:5432/mydb
    depends_on:
      - db

  db:
    image: postgres:15
    restart: always
    volumes:
      - pgdata:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: mydb

volumes:
  pgdata:
```

✅ Highlights:
- `depends_on` for container startup
- Volumes for database persistence
- Use of `DATABASE_URL` for app config

---

## ⚙️ Pattern 2: Microservices Architecture (API Gateway + Services)

```yaml
version: "3.9"

services:
  gateway:
    build: ./gateway
    ports:
      - "80:80"
    depends_on:
      - user
      - orders

  user:
    build: ./services/user
    expose:
      - "4001"

  orders:
    build: ./services/orders
    expose:
      - "4002"

networks:
  default:
    driver: bridge
```

✅ Highlights:
- Simple API Gateway routing to services
- Internal-only communication via `expose`
- Shared default bridge network

---

## ⚙️ Pattern 3: React Frontend + API + MongoDB

```yaml
version: "3.9"

services:
  frontend:
    build: ./frontend
    ports:
      - "8080:80"
    depends_on:
      - backend

  backend:
    build: ./backend
    ports:
      - "5000:5000"
    environment:
      MONGO_URL: mongodb://mongo:27017/app
    depends_on:
      - mongo

  mongo:
    image: mongo:6
    volumes:
      - mongo-data:/data/db

volumes:
  mongo-data:
```

✅ Highlights:
- `frontend` uses NGINX to serve static assets
- MongoDB volume for persistence
- Compose as a frontend+backend+db stack

---

## ⚙️ Pattern 4: Gitpod Dev Environment (`template-docker-compose`)

Inspired by: [Gitpod template](https://github.com/gitpod-samples/template-docker-compose)

```yaml
version: "3.9"

services:
  workspace:
    build: .
    ports:
      - "3000:3000"
    volumes:
      - .:/workspace
    command: bash -c "npm install && npm run dev"

  redis:
    image: redis:7-alpine
```

✅ Highlights:
- Ideal for Gitpod or Codespaces development
- Dev containers pattern using `command`
- Live reload (`npm run dev`) for Node.js apps

---

## ⚙️ Pattern 5: Reverse Proxy + App (NGINX + App)

```yaml
version: "3.9"

services:
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - app

  app:
    image: my-backend
    expose:
      - "3000"
```

✅ Highlights:
- Reverse proxy pattern (production-friendly)
- NGINX as entry point to backend service
- Can scale `app` containers behind proxy

---

## 🧠 Tips for Real Projects

| Tip | Why |
|-----|-----|
| Use `.env` and `env_file` | Cleanly separate config from code |
| Combine multiple `docker-compose.yml` files | Environment-specific overrides |
| Keep volumes named, not bind-mounted, in prod | Avoid host-dependent paths |
| Use `depends_on` + healthchecks | Improve service start order reliability |
| Use `profiles` to toggle dev tools | Keep optional services lightweight |

---

## 🧪 Patterns You Can Add On

- RabbitMQ or Kafka for message brokers
- Elastic Stack (EFK) for logging pipelines
- Traefik/NGINX Ingress + Let's Encrypt
- Multi-database apps (Postgres + Redis + Mongo)
- Monorepos with `x-extensions` and fragment reuse

---

# 🐳 Docker Compose Deep Cheatsheet (Part 7: CLI, CI/CD, Makefiles, Linting & Best Practices)

---

## 🧰 Docker Compose CLI Mastery

### 🔹 Common Commands

```bash
docker-compose up -d       # Start services in background
docker-compose down        # Stop and remove containers, networks, volumes
docker-compose build       # Build services
docker-compose restart     # Restart all services
docker-compose ps          # List running services
docker-compose logs -f     # Tail logs of all services
docker-compose exec <svc> <cmd>    # Exec command in running container
```

---

### 🔹 Use Multiple Compose Files (Override & Merge)

```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

📌 Order matters: later files override earlier ones.

---

### 🔹 Run with Profiles

```bash
docker-compose --profile debug up
```

---

## 🛠️ Automate with Makefile

```makefile
# Makefile
up:
	docker-compose up -d

down:
	docker-compose down

restart:
	docker-compose down && docker-compose up -d

build:
	docker-compose build

logs:
	docker-compose logs -f

shell:
	docker-compose exec app sh
```

💡 Use `make up` instead of long Compose commands.

---

## ✅ Linting & Validation Tools

### 🔹 Docker Compose Linter (YAML/Best Practices)

- [`docker-compose-linter`](https://github.com/mephux/docker-compose-linter)
- [`yamllint`](https://github.com/adrienverge/yamllint)

```bash
yamllint docker-compose.yml
```

---

### 🔹 Compose Config Validator

```bash
docker-compose config  # Validates and prints merged config
```

---

## 🔄 Docker Compose in CI/CD

### GitHub Actions Example

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    services:
      db:
        image: postgres
        ports:
          - 5432:5432
        env:
          POSTGRES_USER: user
          POSTGRES_PASSWORD: pass
    steps:
      - uses: actions/checkout@v3
      - run: docker-compose -f docker-compose.test.yml up -d
      - run: npm test
```

📌 You can also use `docker compose` with GitHub-hosted runners.

---

## 🔐 Security & Hardening Best Practices

| Best Practice | Description |
|---------------|-------------|
| Use `.env` for secrets | Never hardcode credentials in YAML |
| Use Docker secrets/configs | Mount sensitive files as read-only |
| Drop `root` user | Set `user: node` or use non-root users |
| Limit container capabilities | Use `cap_drop`, `read_only`, `tmpfs`, etc. |
| Enable healthchecks | Detect unhealthy containers |
| Use `restart: unless-stopped` in prod | Ensure auto-recovery |
| Limit exposed ports | Use `expose` for internal-only access |
| Use minimal base images | Eg. `node:alpine`, `python:slim` |
| Audit image layers | Use `docker scan` or Trivy for CVEs |
| Update dependencies | Outdated base images are a major attack vector |

---

## 📁 Bonus: Recommended `.dockerignore`

```dockerignore
node_modules
.env
.git
.gitignore
Dockerfile*
docker-compose*
*.log
coverage/
dist/
```

---

## 🧪 Recommended Project Structure

```
my-app/
├── docker-compose.yml
├── docker-compose.override.yml
├── docker-compose.prod.yml
├── .env
├── .dockerignore
├── Makefile
└── src/
```

---

## 🎉 Final Thoughts

You now have a **7-part deep-dive cheatsheet** to confidently use Docker Compose in:
- Local dev 🛠️
- Multi-env deployments 🌍
- CI/CD pipelines 🤖
- Secure production apps 🔒

---
