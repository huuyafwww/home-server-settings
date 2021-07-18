# Run as login user after root user settings.

source ${HOME}/home-server-settings/.env;
source ${HOME}/.env.ex;

cd /home/${LOGIN_USER}/;
mkdir .ssh;
chmod 700 .ssh;
touch .ssh/authorized_keys;
chmod 600 .ssh/authorized_keys;

echo "export LINE_ACCESS_TOKEN=${LINE_ACCESS_TOKEN}" >> /home/${LOGIN_USER}/.env.ex;

cp ${HOME}/home-server-settings/notify_to_line_on_login_shell.sh /home/${LOGIN_USER}/notify_to_line_on_login_shell.sh;
chown -R ${LOGIN_USER}:${LOGIN_USER} /home/${LOGIN_USER}/notify_to_line_on_login_shell.sh;
chmod u+x /home/${LOGIN_USER}/notify_to_line_on_login_shell.sh;

echo "alias vim='`which vi`'
export LANG=en_US
source /home/${LOGIN_USER}/.env.ex
/home/${LOGIN_USER}/notify_to_line_on_login_shell.sh" >> /home/${LOGIN_USER}/.bashrc;
