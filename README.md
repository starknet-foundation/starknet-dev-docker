# Docker Image for Cairo Development

This is a lightweight Docker image for Cairo development that is automatically build and pushed to Docker Hub under the name [starknetfoundation/starknet-dev](https://hub.docker.com/repository/docker/starknetfoundation/starknet-dev/general) every time a new tag is pushed to the repo. The repository tag will become the tag of the image and it indicates the Cairo version supported by the image.

## Run Locally

When modifying the image, make sure it works by running the `test` service from `docker compose` that runs Starknet Foundry tests on the sample Starknet smart contract found in this repo.

```
docker compose run --rm test
```

## Publish Image

Make your local changes in the `main` branch and push the changes to the remote repo.

```
git push origin main
```

Then, create a local tag that will be used as the tag of the image on Docker Hub.

```
git tag 2.6.5
```

Push the local tag to the remote repo to trigger the Github action

```
git push origin 2.6.5
```

Verify that the Github action published the image to [Docker Hub](https://hub.docker.com/repository/docker/starknetfoundation/starknet-dev/general).