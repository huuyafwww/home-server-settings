# Run as login user after root user settings.
source ${HOME}/home-server-settings/.env;

cd /home/${LOGIN_USER}/;
mkdir .ssh;
chmod 700 .ssh;
touch .ssh/authorized_keys;
chmod 600 .ssh/authorized_keys;

echo "alias vim='`which vi`'
export LANG=en_US" >> /home/${LOGIN_USER}/.bashrc;
