FROM alpine:latest

RUN apk update && apk upgrade
RUN apk add --no-cache nodejs npm git curl zsh

# Set zsh as the default shell
SHELL ["/bin/zsh", "-c"]
ENV SHELL /bin/zsh

# For security reason, it's best to create a user to avoid using root by default
RUN adduser -D appuser
USER appuser

ENV HOME /home/appuser
ENV PATH $PATH:$HOME/.local/bin

# Install oh-my-zsh
RUN ash -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Scarb
RUN ash -c "$(curl -fsSL https://docs.swmansion.com/scarb/install.sh)" -s -- -v 2.6.3

# Install Starknet Foundry
RUN ash -c "$(curl -fsSL https://raw.githubusercontent.com/foundry-rs/starknet-foundry/master/scripts/install.sh)" -s
RUN snfoundryup -v 0.23.0

WORKDIR /app