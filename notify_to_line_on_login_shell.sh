#!/bin/sh

line_notify(){
  referrer_ipaddress=${!1};
  message="shellにログインしました：${referrer_ipaddress}";
  curl "https://notify-api.line.me/api/notify" \
    -s \
    -XPOST \
    --header "Authorization: Bearer ${LINE_ACCESS_TOKEN}" \
    --form "message=${message}" \
    > /dev/null;
};

isLocalNetworkReffered(){
  referrer_ipaddress=${!1};
  if [ "`echo "${referrer_ipaddress}" | grep "192.168.0"`" ]; then
    return 1;
  else
    return 0;
  fi
}

isSameGlobalIpAddress(){
  referrer_ipaddress=${!1};
  global_ipaddress=`cat /tmp/global_ipaddress`;
  if [ ${referrer_ipaddress} == ${global_ipaddress} ]; then
    return 1;
  else
    return 0;
  fi
}

record_last_referrer_ipaddress(){
  last_referrer_ipaddress=${!1};
  echo ${last_referrer_ipaddress} > /tmp/referrer_ipaddress;
};

referrer_ipaddress=`echo ${SSH_CLIENT} | cut -f1 -d' '`;
last_referrer_ipaddress=`cat /tmp/referrer_ipaddress`;

# 最後にアクセスしたリファラIPアドレスの場合
if [ ${referrer_ipaddress} == ${last_referrer_ipaddress} ]; then
  exit;
fi

isLocalNetworkReffered referrer_ipaddress;

# ローカルネットワーク経由のログインの場合
if [ ${?} -eq 1 ]; then
  exit;
fi

isSameGlobalIpAddress referrer_ipaddress;

# ローカルネットワーク内のサーバにインターネットゲートウェイ経由でアクセスしている場合
if [ ${?} -eq 1 ]; then
  exit;
fi

# shellにログインしたIPアドレスをLINEに通知する
line_notify referrer_ipaddress;

# リファラIPアドレスを記録する
record_last_referrer_ipaddress referrer_ipaddress;

exit;
