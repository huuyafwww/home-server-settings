
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

echo "LINE_ACCESS_TOKEN=${access_token}" >> ${HOME}/.env.ex;

echo "完了！";
