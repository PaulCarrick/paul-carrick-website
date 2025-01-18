# !/bin/sh
set -e

if [ -f "/rails/initrails.d/env" ]; then . /rails/initrails.d/env ; fi

if [ "${STARTUP}" = "true" ]; then
    mkdir /rails/gems

    export GEM_HOME=/rails/gems

    # Setup Rails
    echo "Running bundle install"
    bundle install
    echo "Running database migrations..."
    bundle exec rails db:migrate

    if [ "RAILS_ENV" == "production" ]; then rails assets:precompile ; fi

    # Start the Rails server
    exec "$@"
fi
