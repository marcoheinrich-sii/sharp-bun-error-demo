# Create a build stage to install all npm dependencies and build the application
FROM oven/bun:alpine AS build-stage

WORKDIR /app

COPY package.json ./
COPY bun.lockb ./

# install the dependencies from the package.json file
RUN bun install
# RUN bun install @img/sharp-linuxmusl-x64 @img/sharp-libvips-linuxmusl-x64
COPY . .

RUN bun build.ts

# Stage 2: Setup the runtime environment
FROM oven/bun:alpine AS runtime-stage

# Install all the fonts
RUN apk update && apk upgrade

RUN mkdir -p /usr/src/app

# Create a group named appusers and add a user called app to it. 
RUN addgroup -S appusers && adduser -S app -G appusers

# Change the ownership of the /usr/src/app directory to the app user
RUN chown -R app:appusers /usr/src/app

RUN mkdir -p /home/app
RUN chown -R app:appusers /home/app

# Copy built code from the build stage
COPY --from=build-stage /app/dist /usr/src/app
# COPY --from=build-stage /app/node_modules/sharp /usr/src/app/node_modules/sharp
# COPY --from=build-stage /app/node_modules/semver /usr/src/app/node_modules/semver

# Switch to the new user
USER app

WORKDIR /usr/src/app
COPY --chown=app:appusers package.json ./

EXPOSE 4000
CMD [ "bun" ,"run", "index.js" ]
