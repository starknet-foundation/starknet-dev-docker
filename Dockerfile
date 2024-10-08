FROM alpine:latest

RUN apk update && apk upgrade
RUN apk add --no-cache nodejs npm git curl zsh

# Set zsh as the default shell
SHELL ["/bin/zsh", "-c"]
ENV SHELL=/bin/zsh

# For security reason, it's best to create a user to avoid using root by default
RUN adduser -D appuser
USER appuser

ENV HOME=/home/appuser
ENV PATH=$PATH:$HOME/.local/bin

# Install oh-my-zsh
RUN ash -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Scarb
RUN curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh -s -- -v 2.8.4

# Install Starknet Foundry
RUN ash -c "$(curl -fsSL https://raw.githubusercontent.com/foundry-rs/starknet-foundry/master/scripts/install.sh)" -s
RUN snfoundryup -v 0.31.0

# Download starknet-devnet binary based on host architecture
RUN ARCH=$(uname -m) && \
    echo "Architecture detected: $ARCH" && \
    if [ "$ARCH" = "x86_64" ]; then \
        echo "Installing binary for x86_64"; \
        curl -sSfL https://github.com/0xSpaceShard/starknet-devnet-rs/releases/download/v0.2.0/starknet-devnet-x86_64-unknown-linux-musl.tar.gz | tar -xvz -C /home/appuser/.local/bin; \
    elif [ "$ARCH" = "aarch64" ]; then \
        echo "Installing binary for ARM64"; \
        curl -sSfL https://github.com/0xSpaceShard/starknet-devnet-rs/releases/download/v0.2.0/starknet-devnet-aarch64-unknown-linux-musl.tar.gz | tar -xvz -C /home/appuser/.local/bin; \
    else \
        echo "Unknown architecture: $ARCH"; \
        exit 1; \
    fi

WORKDIR /app