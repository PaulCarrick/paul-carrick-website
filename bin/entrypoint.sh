#!/bin/bash
set -e

if [ -n "$SSH_PORT" ]; then sudo service ssh start; fi

# Run database migrations
# echo "Running bundle install"
# bundle install
# echo "Running database migrations..."
# bundle exec rails db:migrate

# if [ "RAILS_ENV" == "production" ]; then rails assets:precompile ; fi

# Start the Rails server
# exec "$@"

while true; do # Sleep for debugging and access without server running
  sleep 300
done
