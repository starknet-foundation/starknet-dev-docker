FROM ubuntu:24.04

# Update current packages
RUN apt update && apt upgrade -y

# Install new packages
RUN apt install -y nodejs npm git curl zsh build-essential vim

# Clean up after install to reduce image size
RUN apt clean && rm -rf /var/lib/apt/lists/*

# For security reason, it's best to create a user to avoid using root by default
RUN useradd -m -s /bin/zsh appuser
USER appuser

ENV HOME=/home/appuser
ENV PATH=$PATH:$HOME/.local/bin

# Install oh-my-zsh
RUN curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh -s

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="$HOME/.cargo/bin:$PATH"

# Install Starkli
RUN curl --proto '=https' --tlsv1.2 -sSf https://get.starkli.sh | sh -s
ENV PATH=$PATH:$HOME/.starkli/bin
RUN starkliup

# Install Scarb
RUN curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh -s -- -v 2.9.2

# Install Starknet Foundry
RUN curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/foundry-rs/starknet-foundry/master/scripts/install.sh | sh -s
RUN snfoundryup -v 0.35.1

# Download starknet-devnet binary based on host architecture
RUN ARCH=$(uname -m) && \
    echo "Architecture detected: $ARCH" && \
    if [ "$ARCH" = "x86_64" ]; then \
        echo "Installing binary for x86_64"; \
        curl -sSfL https://github.com/0xSpaceShard/starknet-devnet-rs/releases/download/v0.2.3/starknet-devnet-x86_64-unknown-linux-musl.tar.gz | tar -xvz -C ${HOME}/.local/bin; \
    elif [ "$ARCH" = "aarch64" ]; then \
        echo "Installing binary for ARM64"; \
        curl -sSfL https://github.com/0xSpaceShard/starknet-devnet-rs/releases/download/v0.2.3/starknet-devnet-aarch64-unknown-linux-musl.tar.gz | tar -xvz -C ${HOME}/.local/bin; \
    else \
        echo "Unknown architecture: $ARCH"; \
        exit 1; \
    fi

WORKDIR /app
