FROM debian:bookworm

# Suppress prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install packages
RUN apt-get update && \
    apt-get install -y \
    zsh \
    vim \
    git \
    curl \
    sudo \
    gnupg \
    locales && \
    # Clean up apt cache to reduce image size
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Create a non-root user
ARG USERNAME=guest
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install Docker and Docker Compose
RUN apt-get update && \
    # Add Docker's official GPG key
    apt-get install -y ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg \
    -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    # Add the repository to apt sources
    echo \
    "deb [arch=$(dpkg --print-architecture) \
    signed-by=/etc/apt/keyrings/docker.asc] \
    https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    # Install the latest version
    apt-get update && \
    apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin && \
    # Clean up apt cache to reduce image size
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Switch to the non-root user
USER $USERNAME

# Set the HOME environment variable
ENV HOME=/home/$USERNAME
# Set the working directory to the user's home directory
WORKDIR $HOME

# Install nvm, Node.js and npm
ARG NODE_VERSION=22.11.0
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash && \
    # Set the NVM_DIR environment variable
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && \
    printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" && \
    # Load nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    # Install Node.js
    nvm install $NODE_VERSION && \
    # Activate the specified Node.js version
    nvm use $NODE_VERSION && \
    # Set the specified Node.js version as default for nvm
    nvm alias default $NODE_VERSION

# Add nvm and Node.js to PATH
# It is assumed that $NVM_DIR is $HOME/.nvm because $XDG_CONFIG_HOME is usually
# not set in Debian containers
ENV PATH=$HOME/.nvm/versions/node/v$NODE_VERSION/bin:$PATH

# Install chezmoi in ~/.local/bin and initialize the repository
ARG CHEZMOI_REPO=TimoSutterer
RUN sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply $CHEZMOI_REPO

# Set Zsh as the default shell
SHELL ["/bin/zsh", "-c"]

# Use Zsh as the default process for the container
CMD ["zsh"]
