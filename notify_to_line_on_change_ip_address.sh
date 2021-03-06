#!/bin/sh

line_notify(){
  new_ipaddress=${!1};
  message="IPアドレスが変わりました。${new_ipaddress}";
  curl "https://notify-api.line.me/api/notify" \
    -s \
    -XPOST \
    --header "Authorization: Bearer ${LINE_ACCESS_TOKEN}" \
    --form "message=${message}" \
    > /dev/null;
};

record_new_ipaddress(){
  new_ipaddress=${!1};
  echo ${new_ipaddress} > /tmp/global_ipaddress;
};

new_ipaddress=`curl -s ifconfig.io`;
global_ipaddress=`cat /tmp/global_ipaddress`;

# IPアドレスが変わっていない場合は終了
if [ ${new_ipaddress} == ${global_ipaddress} ]; then
  exit;
fi

# LINEに新しいIPアドレスを通知する
line_notify new_ipaddress;

# 新しいIPアドレスを記録する
record_new_ipaddress new_ipaddress;
exit;
