FROM ubuntu:latest

RUN apt update && apt upgrade -y
RUN apt install git curl zsh -y

# Change default shell to zsh
SHELL ["/bin/zsh", "-lc"]

# Set environment variables
ENV SHELL /bin/zsh
ENV HOME /root
ENV PATH $PATH:$HOME/.bin:$HOME/.local/bin

# Install oh-my-zsh for VSCode's DevContainer plugin
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install and configure asdf
RUN git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.14.0

# Enable oh-my-zsh plugin for asdf
RUN sed -i 's/plugins=(git)/plugins=(git asdf)/' $HOME/.zshrc

# Source changes to configuration file
RUN source $HOME/.zshrc

# Add asdf binaries to path
ENV PATH $PATH:$HOME/.asdf/bin:$HOME/.asdf/shims

# Install common dependenies with asdf
RUN asdf plugin add scarb
RUN asdf install scarb 2.5.4
RUN asdf global scarb 2.5.4

RUN asdf plugin add starknet-foundry
RUN asdf install starknet-foundry 0.18.0
RUN asdf global starknet-foundry 0.18.0

RUN asdf plugin add nodejs
RUN asdf install nodejs 21.6.1
RUN asdf global nodejs 21.6.1

WORKDIR /app