# !/bin/bash

# Optional setup access for non-rails user. This needs to be done in the runtime after the home direcoty is mounted.
if [ -n "$SSH_PORT" -a -n "$SSH_PUBLIC_KEY" -a -n "$USERNAME" -a ! -e "/home/${USERNAME}/.ssh/authorized_keys" ]; then
      echo "$SSH_PUBLIC_KEY" > /home/${USERNAME}/.ssh/authorized_keys && \
      chmod 600 /home/${USERNAME}/.ssh/authorized_keys && \
      chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh
fi

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
