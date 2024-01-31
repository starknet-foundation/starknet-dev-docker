# Docker Image for Developing on Starknet

This is the source code of [this image](https://hub.docker.com/repository/docker/barretodavid/starknet-dev/general) found in Docker Hub.

To make sure the image works, run the `test` service from `docker compose`.

This service runs a series of integration tests created with [Starknet Foundry](https://foundry-rs.github.io/starknet-foundry/) for a sample `Counter` smart contract written in [Cairo](https://book.cairo-lang.org/).

```
docker compose run --rm test
```

To build and tag the image:

```
docker build -t barretodavid/starknet-dev:<tag> .
```

To push the image to Docker hub:

```
docker push barretodavid/starknet-dev:<tag>
```

`username` is the Docker hub username

`tag` can be a specific version of the image or `latest`