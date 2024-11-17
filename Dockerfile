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

# Switch to the non-root user
USER $USERNAME

# Set the working directory to the user's home directory
WORKDIR /home/$USERNAME

# Create empty .zshrc file
RUN touch .zshrc

# Set Zsh as the default shell
SHELL ["/bin/zsh", "-c"]

# Use Zsh as the default process for the container
CMD ["zsh"]
