FROM alpine:latest

RUN apk update && apk upgrade
RUN apk add --no-cache nodejs npm git curl

ENV HOME /root
ENV PATH $PATH:$HOME/.bin:$HOME/.local/bin

# Install Scarb
RUN ash -c "$(curl -fsSL https://docs.swmansion.com/scarb/install.sh)" -s -- -v 2.6.3

# Install Starknet Foundry
RUN ash -c "$(curl -fsSL https://raw.githubusercontent.com/foundry-rs/starknet-foundry/master/scripts/install.sh)" -s
RUN /root/.local/bin/snfoundryup -v 0.20.0

WORKDIR /app