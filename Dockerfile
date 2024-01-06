FROM node:18-alpine as BUILD_IMAGE
WORKDIR /app

# Copy packages.json
COPY package.json .
COPY package-lock.json .

# Install all out pachages
RUN npm install

# Copy all remaining files
COPY . .

# Build Project
RUN npm run build

# Here, we are implementing the multi-stage build. It greatly reduces our size
# it also won't expose our code in our container as we will only copy
# the build output from the first stage

# begining og second stage
FROM node:18-alpine as PRODUCTION_IMAGE
WORKDIR /app 

# Here we are copying /app/react-app/dist folder from BUILD_IMAGE to
# /app/react-app/dist in this stage.


COPY --from=BUILD_IMAGE /app/dist/ ./dist

# To run npm commands as: npm run preview
# We need packege.json
COPY package.json .
COPY vite.config.js .

EXPOSE 8001
CMD ["npm", "run", "preview"]

