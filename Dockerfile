# This stage exists so we can parameterize the uv image version via ARG.
# Docker does not allow COPY --from=<image:tag> to use variables, so we
# load the versioned image here and give the stage a fixed name.
ARG UV_VERSION=0.9.9
FROM docker.io/astral/uv:${UV_VERSION} AS uv

FROM debian:bookworm

# Suppress prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install packages
RUN apt-get update && \
    apt-get install -y \
    zsh \
    vim \
    git \
    bat \
    curl \
    sudo \
    tmux \
    gnupg \
    locales && \
    # Clean up apt cache to reduce image size
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up locales
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install Neovim
# Neovim is installed from the pre-build archive because the version in the
# Debian repository is outdated
ARG NVIM_VERSION=v0.11.5
RUN curl -LO https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz && \
    rm -rf /opt/nvim && \
    tar -C /opt -xzf nvim-linux-x86_64.tar.gz && \
    rm nvim-linux-x86_64.tar.gz
# Add Neovim to PATH
ENV PATH=$PATH:/opt/nvim-linux-x86_64/bin

# Install delta
ARG DELTA_VERSION=0.18.2
RUN apt-get update \
 && apt-get install -y curl dpkg less ca-certificates \
 && curl -fsSL \
    https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_amd64.deb \
    -o /tmp/delta.deb \
 && dpkg -i /tmp/delta.deb \
 && rm -rf /var/lib/apt/lists/* /tmp/delta.deb

# Create a non-root user
ARG USERNAME=guest
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME --shell /bin/zsh && \
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

# Set XDG Base Directory Specification environment variables
ENV XDG_CONFIG_HOME=$HOME/.config \
    XDG_DATA_HOME=$HOME/.local/share \
    XDG_CACHE_HOME=$HOME/.cache \
    XDG_STATE_HOME=$HOME/.local/state \
    XDG_RUNTIME_DIR=$HOME/.local/run
# Create directories for XDG Base Directory Specification
RUN mkdir -p $XDG_CONFIG_HOME $XDG_DATA_HOME $XDG_CACHE_HOME $XDG_STATE_HOME $XDG_RUNTIME_DIR

# Install nvm, Node.js and npm
ARG NVM_VERSION=0.40.3
ARG NODE_VERSION=22.17.0
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VERSION/install.sh | bash && \
    # Set the NVM_DIR environment variable
    export NVM_DIR=$XDG_CONFIG_HOME/nvm && \
    # Load nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    # Install Node.js
    nvm install $NODE_VERSION && \
    # Activate the specified Node.js version
    nvm use $NODE_VERSION && \
    # Set the specified Node.js version as default for nvm
    nvm alias default $NODE_VERSION

# Add nvm and Node.js to PATH
ENV PATH=$XDG_CONFIG_HOME/nvm/versions/node/v$NODE_VERSION/bin:$PATH

# Install uv by copying binaries from the uv image/stage
COPY --from=uv /uv /uvx /bin/

# Copy the local repository into the container
COPY --chown=$USERNAME:$USERNAME . $XDG_DATA_HOME/chezmoi
# Install chezmoi in ~/.local/bin
RUN sh -c "$(curl -fsLS get.chezmoi.io/lb)"
# Install dotfiles
ARG CHEZMOI_REPO=TimoSutterer
RUN if [ -z "$CHEZMOI_REPO" ]; then \
        # CHEZMOI_REPO is empty, use local repository
        $HOME/.local/bin/chezmoi init --apply; \
    else \
        # CHEZMOI_REPO is not empty, use repository from URL
        rm -rf $XDG_DATA_HOME/chezmoi && \
        $HOME/.local/bin/chezmoi init --apply $CHEZMOI_REPO; \
    fi

# Pre-initialize shell environment to speed up first container start
# This sources the zsh configuration which triggers zinit plugin installation
# and configuration setup, avoiding the delay when starting the container
RUN zsh -c "source ~/.zshrc"

# Pre-compile gitstatus binary for Powerlevel10k theme
# Without this, the binary would be compiled on first zsh start, causing delay
RUN zsh -c "$XDG_DATA_HOME/zinit/plugins/romkatv---powerlevel10k/gitstatus/install"

# Pre-install and sync all Neovim plugins using lazy.nvim
# This downloads and installs all plugins defined in the Neovim configuration
# Without this, plugins would be installed on first Neovim launch, causing delay
RUN nvim --headless "+Lazy! sync" +qa

# Set the default command to start or attach to a tmux session named 'default'
CMD ["tmux", "new-session", "-A", "-s", "default"]
