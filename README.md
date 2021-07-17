# Linux-Config

##  :memo:藉由學習Linux同時，將Linux的重要Configuration Files path和相關參數記下來

:pushpin:`========== [帳號、密碼、群組資訊] ==========`  
/etc/passwd: 系統上的帳號與一般身份使用者，還有root的相關資訊  
/etc/shadow: 個人的密碼  
/etc/group: Linux所有的群組名稱  

:pushpin:`========== [Bootloader] ==========`  
/boot/efi/EFI/centos/grub.cfg #GRUB最主要的組態檔  
/etc/grub.d/ #user輸入grub2-mkconfig -o /boot/grub2/grub.cfg指令後(簡化可以輸入update-grub)，會去執行此目錄底下的腳本  
/etc/default/grub #設定boot menu，更改完輸入grub2-mkconfig設定  !!通常使用者只須設定此檔案即可, 上述2個檔案不更改  

:pushpin:`========== [Log] ==========`  
/etc/rsyslog.conf #log登錄檔的設定檔  

:pushpin:`========== [File System] ==========`  
/etc/fstab #規定磁碟開機時掛載點及如何掛載等選項  

:pushpin:`========== [Internet] ==========`  
/etc/hosts #網路相關設定  
/etc/sysconfig/network-scripts/icfg-eth0 #網卡設定檔  
/etc/dhcp/dhclient.conf #dhcp client向dhcp server發送req的設定參數檔  
/etc/dhcp/dhcpd.conf #dhcp server主要設定檔  
/etc/ssh/sshd_config #ssh連線設定檔  
/etc/ssh/ssh_config #ssh client設定檔  

:pushpin:`========== [System] ==========`   
/etc/.bashrc #bash的環境設定檔  
/etc/crontab #設定例行性工作排程  
