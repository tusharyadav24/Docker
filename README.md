# Docker

A minimal Node.js application built with Express and Mongoose, packaged with a `Dockerfile` based on `node:20-alpine`.

## Project Structure

```text
.
├── .gitignore         # Ignores node_modules/
├── Dockerfile         # Container image definition (node:20-alpine)
├── app.js             # Express server and MongoDB connection setup
├── package.json       # Project dependencies (express, mongoose)
└── package-lock.json  # Locked dependency tree
```

## Tech Stack & Dependencies

- **Runtime:** Node.js (`node:20-alpine` in `Dockerfile`; `mongoose` specifies `node >= 20.19.0`)
- **Web Framework:** `express` (`^5.3.0`)
- **ODM / Database:** `mongoose` (`^9.11.4`) connecting to MongoDB (`mongodb://127.0.0.1:27017/docker`)
- **Containerization:** Docker

## Getting Started (Local)

### Prerequisites

- Node.js (`>= 20.19.0` recommended) and npm
- A running MongoDB instance listening on `127.0.0.1:27017`

### Steps

1. Clone the repository:

   ```bash
   git clone https://github.com/tusharyadav24/Docker.git
   cd Docker
   ```

2. Install dependencies:

   ```bash
   npm install
   ```

3. Start the application:

   ```bash
   node app.js
   ```

   On startup, the server listens on port `8080` and logs:
   - `app is listening`
   - `Connected!` (once the Mongoose connection to `mongodb://127.0.0.1:27017/docker` succeeds)

## Docker Usage

### Build the Image

The `Dockerfile` uses `node:20-alpine`, sets `/app` as the working directory, copies `package*.json` to install production dependencies (`npm install --omit=dev`), and copies the project files:

```bash
docker build -t docker-app .
```

### Run the Container

Because `package.json` does not currently define a `start` script and `app.js` listens on port `8080`, override the default `CMD ["npm", "start"]` when running the image as-is:

```bash
docker run --rm -p 8080:8080 docker-app node app.js
```

> [!NOTE]
> Inside a container, `mongodb://127.0.0.1:27017/docker` resolves to the container's own loopback interface rather than your host machine or a separate MongoDB container. To reach an external MongoDB instance from the container, update the connection string (for example, via an environment variable) or configure appropriate Docker networking.

## Current Configuration Notes

If you plan to deploy or extend this project, keep these details from the current codebase in mind:

- **Missing `start` script:** `Dockerfile` ends with `CMD ["npm", "start"]`, while `package.json` has no `scripts.start` entry yet. Adding `"scripts": { "start": "node app.js" }` to `package.json` allows `docker run` to work without overriding the command.
- **Port mismatch:** `Dockerfile` sets `EXPOSE 3000`, whereas `app.js` calls `app.listen(8080, ...)`.
- **Routes:** `app.js` initializes the Express app and MongoDB connection without defining any HTTP routes yet.
- **Docker build context:** No `.dockerignore` file is present yet, so `COPY . .` will include local directories such as `node_modules/` if present locally.
