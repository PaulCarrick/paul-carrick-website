# !/bin/bash

if [ -n "$SSH_PORT" ]; then service ssh start; fi

# TODO
# I cannot find a way to setup the ownership of the files in Docker build.
# You would think that chown rails:rails -R /rail would work but it doesn't.
# I consulted ChatGPT and google and neither could provide an answer.
# For now, do it at runtime where it works.

chown -R rails:rails /rails
su rails -c "cd /rails && /rails/bin/startup.sh $@"

while true; do # Sleep for debugging and access without server running
  sleep 300
done
