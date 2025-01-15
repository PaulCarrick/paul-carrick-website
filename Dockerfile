# DockerFile

# syntax=docker/dockerfile:1
# check=error=true

# Base Ruby image
ARG RUBY_VERSION=3.2.6
FROM ruby:${RUBY_VERSION} AS base

# Set working directory
WORKDIR /rails

ARG NODE_VERSION=23.2.0
ENV NODE_VERSION=${NODE_VERSION}
ARG YARN_VERSION=1.22.22
ENV YARN_VERSION=${YARN_VERSION}

# Allow conditional SSH setup
ARG SSH_PORT=""
ENV SSH_PORT=${SSH_PORT}
ARG SSH_PUBLIC_KEY=""
ENV SSH_PUBLIC_KEY=${SSH_PUBLIC_KEY}

# Allow conditional SUDO setup
ARG SUDO_AVAILABLE=""
ENV SUDO_AVAILABLE=${SUDO_AVAILABLE}

ARG SUDO_USER_PASSWORD
ENV SUDO_USER_PASSWORD=${SUDO_USER_PASSWORD}

# Setup Database
ARG DB_PASSWORD
ENV DB_PASSWORD=$DB_PASSWORD

# Set default Server ports
ARG INTERNAL_PORT=80
ENV INTERNAL_PORT=${INTERNAL_PORT}
ARG EXTERNAL_PORT=80
ENV EXTERNAL_PORT=${EXTERNAL_PORT}

RUN echo "Current Configuration:" && env

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libjemalloc2 \
    libvips \
    postgresql-client \
    openssl \
    build-essential \
    procps \
    libyaml-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Optionally install ssh
RUN if [ -n "$SSH_PORT" ]; then \
      apt-get update -qq && \
      apt-get install --no-install-recommends -y sudo openssh-server && \
      rm -rf /var/lib/apt/lists /var/cache/apt/archives; \
    fi

# Optionally install sudo and net tools
RUN if [ "${SUDO_AVAILABLE}" = "true" ]; then \
      apt-get update -qq && \
      apt-get install --no-install-recommends -y sudo iproute2 telnet curl && \
      rm -rf /var/lib/apt/lists /var/cache/apt/archives; \
    fi

# Install the correct Bundler version
RUN gem install bundler -v '~> 2.5'

# Set production environment variables
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test"

# Configure SSH
RUN if [ -n "$SSH_PORT" ]; then \
      set -e; \
      mkdir /var/run/sshd && \
      echo "PasswordAuthentication no" >> /etc/ssh/sshd_config && \
      echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config && \
      echo "AuthorizedKeysFile %h/.ssh/authorized_keys" >> /etc/ssh/sshd_config; \
    fi

# Build stage
FROM base AS build

# Install packages for gem and JavaScript dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    git \
    libpq-dev \
    node-gyp \
    pkg-config \
    python-is-python3 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install Node.js and Yarn
ENV PATH="/usr/local/node/bin:$PATH"
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION && \
    rm -rf /tmp/node-build-master

# Copy and install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .
RUN bundle exec bootsnap precompile app/ lib/
RUN SECRET_KEY_BASE=DUMMY bundle exec rails assets:precompile
RUN rm -rf node_modules

# Final stage
FROM base

# Copy build artifacts
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Set up non-root user
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash

# Optionally setup sudo user
RUN if [ "${SUDO_AVAILABLE}" = "true" ]; then \
      set -e; \
      echo "Adding group sudoer"; \
      groupadd --system --gid 1001 sudoer; \
      echo "Adding user sudoer"; \
      useradd sudoer --uid 1001 --gid 1001 --create-home --shell /bin/bash; \
      echo "Setting password for sudoer"; \
      echo "sudoer:${DB_PASSWORD}" | chpasswd; \
      echo "Configuring sudo access for sudoer"; \
      echo "sudoer ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/sudoer; \
      chmod 0440 /etc/sudoers.d/sudoer; \
    fi

RUN if [ -n "$SSH_PORT" ]; then \
      set -e; \
      mkdir -p /home/rails/.ssh && \
      chmod 700 /home/rails/.ssh && \
      chown -R rails:rails /home/rails/.ssh; \
    fi

RUN if [ -n "$SSH_PUBLIC_KEY" ]; then \
      set -e; \
      echo "$SSH_PUBLIC_KEY" > /home/rails/.ssh/authorized_keys && \
      chmod 600 /home/rails/.ssh/authorized_keys && \
      chown -R rails:rails /home/rails/.ssh; \
    fi

# Expose HTTPS and SSH ports
EXPOSE ${EXTERNAL_PORT} ${SSH_PORT}

# Start Rails server (and optionall SSH Server)
CMD ["/bin/bash", "-c", \
    "service ssh start && /rails/bin/entrypoint.sh /rails/bin/rails server -b 0.0.0.0 -p ${INTERNAL_PORT}"]
