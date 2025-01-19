# !/bin/bash

if [ -f "/rails/initrails.d/env" ]; then . /rails/initrails.d/env ; fi

if [ -n "$SSH_PORT" ]; then service ssh start; fi

if [ "${STARTUP}" = "true" ]; then
    # Optional setup access for non-rails user. This needs to be done in the runtime after the home directory is mounted.
    if [ -n "$SSH_PORT" -a -n "$SSH_PUBLIC_KEY" -a -n "$USERNAME" -a ! -e "/home/${USERNAME}/.ssh/authorized_keys" ]; then
          echo "$SSH_PUBLIC_KEY" > /home/${USERNAME}/.ssh/authorized_keys && \
          chmod 600 /home/${USERNAME}/.ssh/authorized_keys && \
          chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh
    fi

    if [ -z "$(ls -A /rails/storage)" -a -f /rails/initrails.d/storage.tar.gz ]; then
      pushd /rails
      tar -xzvf initrails.d/storage.tar.gz
      popd
    fi

    # TODO
    # I cannot find a way to setup the ownership of the files in Docker build.
    # You would think that chown rails:rails -R /rail would work but it doesn't.
    # I consulted ChatGPT and google and neither could provide an answer.
    # For now, do it at runtime where it works.

    chown -R rails:rails /rails
    su rails -c "cd /rails && /rails/initrails.d/startup.sh $@"
fi

while true; do # Sleep for debugging and access without server running
  sleep 300
done
