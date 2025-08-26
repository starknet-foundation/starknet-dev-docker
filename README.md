# Docker Image for Cairo Development

This is a lightweight Docker image for Cairo development that is automatically build and pushed to Docker Hub under the name [starknetfoundation/starknet-dev](https://hub.docker.com/repository/docker/starknetfoundation/starknet-dev/general) every time a new tag is pushed to the repo. The repository tag will become the tag of the image and it indicates the Cairo version supported by the image.

## Publish with Git Action

Push the changes to the remote repo.

```
git push origin main
```

Create a local tag that will be used as the tag of the image on Docker Hub.

```
git tag 2.12.0
```

Push the local tag to the remote repo to trigger the Github action

```
git push origin 2.12.0
```

Verify that the Github action published the image to [Docker Hub](https://hub.docker.com/repository/docker/starknetfoundation/starknet-dev/general).

## Publish with CLI

Login to Docker Hub

```
docker login
```

Create builder that supports multi-arch builds

```
docker buildx create --name mybuilder --use
docker buildx inspect --bootstrap
```

Build and push the multi-arch image

```
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --tag starknetfoundation/starknet-dev:2.11.4 \
  --tag starknetfoundation/starknet-dev:latest \
  --push \
  .
```