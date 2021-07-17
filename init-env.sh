# Create Environments.

source ${HOME}/home-server-settings/.env;


#### LINEアクセストークン設定

echo "LINEアクセストークンの環境変数設定を行います";

valid_line_access_token(){
  tmp_access_token=${1};
  response=`curl -i "https://notify-api.line.me/api/status" \
    --header "Authorization: Bearer ${tmp_access_token}"`;
  if [ "`echo "${response}" | grep "200"`" ]; then
    return 1
  else
    return 0
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

mkcert --install;

while true
do
  echo -n "ドメインを入力: ";
  read domain;
  echo -n "${domain}で証明書を発行しますか？(y or n)";
  read canContinue;
  echo $'\n';
  if [ "`echo ${canContinue}`" = "y" ]; then
    break;
  fi
done

domains=${domain};

echo -n "ワイルドカード証明書を発行しますか？(y or n)";
read doWildCard;

if [ "`echo ${doWildCard}`" = "y" ]; then
    domains+=" *.${domain}";
fi

mkcert ${domains};

mkdir -r ${CERTICATE_DIRECTORY};

mkcert -cert-file ${PUBLIC_SSL_CERTICATE_FILE} -key-file ${PRIVATE_SSL_CERTICATE_FILE} ${domain};

tmp_conf_file=${HOME}/home-server-settings/conf/nginx/nginx.conf
tmp_default_conf_file=${HOME}/home-server-settings/conf/nginx/conf/default.conf

##### IP制限設定
cat ${tmp_conf_file} | sed s/IP_ADDRESS/`curl -s ifconfig.io`/ > ${tmp_conf_file}

##### SSL証明書パス設定
cat ${tmp_conf_file} | sed s/SSL_CERTIFICATE_KEY/${PRIVATE_SSL_CERTICATE_FILE}/ > ${tmp_conf_file}
cat ${tmp_conf_file} | sed s/SSL_CERTIFICATE/${PUBLIC_SSL_CERTICATE_FILE}/ > ${tmp_conf_file}

##### ホスト設定
cat ${tmp_conf_file} | sed s/HOST/${domain}/g > ${tmp_conf_file}
cat ${tmp_default_conf_file} | sed s/HOST/${domain}/ > ${tmp_default_conf_file}

cp -f ${tmp_conf_file} /etc/nginx/nginx.conf
cp -f ${tmp_default_conf_file} /etc/nginx/conf.d/default.conf

echo "export HOST=${domain}" >> ${HOME}/.env.ex;

echo "完了！";
