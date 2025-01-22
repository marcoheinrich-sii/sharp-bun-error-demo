## Build and run

```sh
# sharp-bun
docker buildx build --load -f ./Dockerfile -t sharpbun .
docker run --name sharp-bun sharpbun
```