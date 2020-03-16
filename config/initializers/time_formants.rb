Time::DATE_FORMATS[:datetime_jp] = '%Y年 %m月 %d日 %H時 %M分'
# 上の記述はcreated_atやupdated_atを日本時間表示刷る時、よりわかりやすく表示するために使います。
#この記述のあとローカル環境なら、rails sを再起動してください。
#使い方は、ビュー上で<%= created_at%>などとしているところは<%= created_at.to_s(:datetime_jp)%>とします。