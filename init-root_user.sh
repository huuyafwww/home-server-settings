# After centos7 is installed, paste it into the CLI as root user and run it.
yum update -y \
&& echo "[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/\$basearch/
gpgcheck=0
enabled=1" > /etc/yum.repos.d/nginx.repo \
&& curl -sL https://rpm.nodesource.com/setup_14.x | bash - \
&& curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo \
&& rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg \
&& yum groupinstall -y "Development Tools" \
&& yum localinstall -y http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm \
&& yum install -y \
    wget \
    https://centos7.iuscommunity.org/ius-release.rpm \
    https://repo.ius.io/ius-release-el7.rpm \
    https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm \
    gettext-devel \
    openssl-devel \
    perl-CPAN \
    perl-devel \
    zlib-devel \
    lzo-devel \
    pam-devel \
    rpm-build \
    epel-release \
    nginx \
    git \
    yum-utils \
    device-mapper-persistent-data \
    lvm2 \
    nodejs \
    mysql-community-server \
    gcc \
    gcc-c++ \
    python36u \
    python36u-libs \
    python36u-devel \
    python36u-pip \
    ffmpeg \
    ffmpeg-devel \
&& yum install -y jq --enablerepo=epel \
&& yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo \
&& yum makecache fast \
&& yum install -y docker-ce \
&& curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m`" -o /usr/local/bin/docker-compose \
&& chmod +x /usr/local/bin/docker-compose \
&& firewall-cmd --add-service=http --zone=public --permanent \
&& firewall-cmd --reload \
&& systemctl start nginx \
&& systemctl enable nginx \
&& python3.6 -m pip install --upgrade pip \
&& npm install -g yarn \
&& touch ${HOME}/.env.ex \
&& echo "alias vim='vi'" >> ${HOME}/.bashrc \
&& echo "alias python='`which python3`'" >> ${HOME}/.bashrc \
&& echo "alias pip='`which pip3`'" >> ${HOME}/.bashrc \
&& echo "export LANG=en_US" >> ${HOME}/.bashrc \
&& echo "source ${HOME}/.env.ex" >> ${HOME}/.bashrc \
&& yum update -y \
&& git clone https://github.com/huuyafwww/home-server-settings.git \
&& cd ${HOME}/home-server-settings \
&& chmod u+x ./init-login_user.sh \
&& ./init-login_user.sh \
&& chmod u+x ./init-env.sh \
&& ./init-env.sh \
&& chmod u+x ./notify_to_line_on_change_ip_address.sh \
&& crontab init-crontab \
&& source ${HOME}/.bashrc \
&& echo "セットアップ完了！"
