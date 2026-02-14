FROM python:3.13-slim-trixie

# Create a dummy .zshrc file so the starship feature can configure it
# This will be overridden by the mount at runtime with your actual .zshrc
RUN mkdir -p /root && echo "# Dummy .zshrc for starship feature installation" > /root/.zshrc

RUN apt-get update && apt-get install -y \
  zsh \
  curl \
  wget \
  fastfetch \
  git \
  fzf \
  zoxide \
  fonts-firacode \
  starship
