FROM node:20-alpine

WORKDIR /app

COPY . .

# Remove husky prepare
RUN sed -i '/"prepare":/d' package.json

# Install production + optional express dependency
RUN npm ci --omit=dev
RUN npm install express
RUN npm cache clean --force

ENV NODE_ENV=production
USER node
CMD ["node", "express.js"]
