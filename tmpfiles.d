# -------------- tmpfiles.d介紹 --------------
systemd-tmpfiles-clean.service取代Red Hat 7以前的tmpwatch指令，用來清除garbage files用的

man 5 tmpfiles.d                  #查看使用手冊
systemd-tmpfiles --create
systemd-tmpfiles --clean

3個設定擋path如下，當執行上述2個指令時，系統會到此3個設定檔內查看
/etc/tmpfiles.d/*.conf            #優先順序1
/run/tmpfiles.d/*.conf            #優先順序2
/usr/lib/tmpfiles.d/*.conf        #優先順序3  (暫存設定檔*.conf幾乎都放在此路徑)

vim /etc/tmpfiled.d/kobe.conf
種類      路徑         權限      uid      gid       time欄位  (種路權ugt)
d         /run/kobe    0770      root     root        30s
d代表如果/run/kobe目錄底下檔案超過30秒沒有修改，當系統被執行systemd-tmpfiles --clean的時候，底下的檔案就會被刪除
