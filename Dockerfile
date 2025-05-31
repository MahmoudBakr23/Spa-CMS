# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development.
# Use with Kamal or manually:
# docker build -t spa_cms .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<your key> --name spa_cms spa_cms

# For containerized dev environments, see:
# https://guides.rubyonrails.org/getting_started_with_devcontainer.html

ARG RUBY_VERSION=3.3.3
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl libjemalloc2 libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment variables
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# ========== Build stage ==========
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential git libpq-dev libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install correct Bundler version from Gemfile.lock
COPY Gemfile.lock ./
RUN BUNDLER_VERSION=$(awk '/BUNDLED WITH/{getline; print $1}' Gemfile.lock) && \
    gem install bundler -v "$BUNDLER_VERSION"

# Copy Gemfile and install gems
COPY Gemfile ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}/ruby/*/cache" "${BUNDLE_PATH}/ruby/*/bundler/gems/*/.git" && \
    bundle exec bootsnap precompile --gemfile

# Copy app source code
COPY . .

# Precompile bootsnap code
RUN bundle exec bootsnap precompile app/ lib/

# Precompile assets with dummy key (so we don't need actual RAILS_MASTER_KEY here)
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# ========== Final stage ==========
FROM base

# Copy all built app and gems
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Create a non-root user and give it ownership of runtime dirs
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

USER 1000:1000

# Entrypoint prepares the DB
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Run the Rails server by default with Thruster
EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]
