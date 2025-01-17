# !/bin/sh
set -e

if [ -f "/rails/env" ]; then . /rails/env ; fi

if [ -z "${NO_START}" ]; then
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
