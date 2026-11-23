FROM node:20-alpine

WORKDIR /app

# Copy dependency files first to leverage Docker layer caching
COPY package*.json ./
RUN npm install --omit=dev

# Copy the rest of the application source code
COPY . .

EXPOSE 3000

CMD ["npm", "start"]