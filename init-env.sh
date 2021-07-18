# Create Environments.

source ${HOME}/home-server-settings/.env;


#### LINEアクセストークン設定

echo "LINEアクセストークンの環境変数設定を行います";

valid_line_access_token(){
  tmp_access_token=${1};
  response=`curl -i "https://notify-api.line.me/api/status" \
    --header "Authorization: Bearer ${tmp_access_token}"`;
  if [ "`echo "${response}" | grep "200"`" ]; then
    return 1;
  else
    return 0;
  fi
}

while true
do
  echo -n "アクセストークンを入力 : ";
  read access_token;
  valid_line_access_token ${access_token};
  if [ ${?} -eq 1 ]; then
    break;
  fi
  echo "有効なアクセストークンではありません";
done

echo "export LINE_ACCESS_TOKEN=${access_token}" >> ${HOME}/.env.ex;

echo "完了！";

#### SSL化設定

echo "SSL化設定を行います";

mkcert --install;

while true
do
  echo -n "ドメインを入力: ";
  read domain;
  echo -n "${domain}で証明書を発行しますか？(y or n)";
  read can_continue;
  echo $'\n';
  if [ "`echo ${can_continue}`" = "y" ]; then
    break;
  fi
done

domains=${domain};

echo -n "ワイルドカード証明書を発行しますか？(y or n)";
read do_wildCard;

if [ "`echo ${do_wildCard}`" = "y" ]; then
    domains+=" *.${domain}";
fi

mkcert ${domains};

mkdir -r ${CERTICATE_DIRECTORY};

mkcert -cert-file ${PUBLIC_SSL_CERTICATE_FILE} -key-file ${PRIVATE_SSL_CERTICATE_FILE} ${domain};

nginx_conf_file=${HOME}/home-server-settings/conf/nginx/nginx.conf
nginx_default_conf_file=${HOME}/home-server-settings/conf/nginx/conf/default.conf

##### IP制限設定
gobal_ipaddress=`curl -s ifconfig.io`;
cat ${nginx_conf_file} | sed s/IP_ADDRESS/${gobal_ipaddress}/ > ${nginx_conf_file};
echo ${gobal_ipaddress} > /tmp/gobal_ipaddress;

##### SSL証明書パス設定
cat ${nginx_conf_file} | sed s/SSL_CERTIFICATE_KEY/${PRIVATE_SSL_CERTICATE_FILE}/ > ${nginx_conf_file};
cat ${nginx_conf_file} | sed s/SSL_CERTIFICATE/${PUBLIC_SSL_CERTICATE_FILE}/ > ${nginx_conf_file};

##### ホスト設定
cat ${nginx_conf_file} | sed s/HOST/${domain}/g > ${nginx_conf_file};
cat ${nginx_default_conf_file} | sed s/HOST/${domain}/ > ${nginx_default_conf_file};

cp -f ${nginx_conf_file} /etc/nginx/nginx.conf;
cp -f ${nginx_default_conf_file} /etc/nginx/conf.d/default.conf;

echo "export HOST=${domain}" >> ${HOME}/.env.ex;

echo "完了！";


#### MySQL設定

echo "MySQLの初回環境構築設定を行います";

echo "character_set_server=utf8
skip-character-set-client-handshake" >> /etc/my.cnf;

mysql_first_password=`cat /var/log/mysqld.log | grep -o "password is generated for.*" | cut -f6 -d' '`;
echo "MySQL初期パスワードは\"${mysql_first_password}\"です";

echo "[client]
user=root
password='${mysql_first_password}'
" > ${HOME}/my.cnf;

echo -n "変更後のパスワードを入力 : ";
read mysql_new_password;

# 変更後のパスワードを引数に付与して対話モード内の該当設定をスキップする
mysql_secure_installation -p${mysql_new_password} --defaults-extra-file ${HOME}/my.cnf --use-default;

echo "[client]
user=root
password='${mysql_new_password}'
" > ${HOME}/my.cnf;

echo "完了！";

#### その他

##### プライベートIPアドレス
echo "export PRIVATE_IP_ADDRESS=`hostname -I`" >> ${HOME}/.env.ex;
