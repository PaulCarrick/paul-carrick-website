#!/bin/bash
set -e

# Run database migrations
echo "Running bundle install"
bundle install
echo "Running database migrations..."
bundle exec rails db:migrate

if [ "RAILS_ENV" == "production" ]; then rails assets:precompile ; fi

# Start the Rails server
exec "$@"

# Check for errors and wait for debugging if necessary
if [ $? -ne 0 ]; then
  echo "An error occurred. The container will wait for debugging."

  while true; do
    sleep 300
  done
fi
