FROM node:25-alpine as builder
WORKDIR /app
COPY package.json tsconfig.json ./
RUN npm install
COPY server.ts ./
RUN npm run build

FROM node:25-alpine
WORKDIR /app
COPY package.json ./
RUN npm install --production
COPY --from=builder /app/dist ./dist
EXPOSE 8080
CMD ["node", "dist/server.js"]
