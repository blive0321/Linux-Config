## -------------------- grep --------------------

## -------------------- awk --------------------
awk '/pattern/ action' file.txt
pattern是正規表達式
action是當找到pattern的內容時，要執行的動作

IFS
在awk裡，IFS的default值是space和tab

印出所有的行
`awk '{print}' /etc/hosts`
找出127開頭的行
`awk '^127' /etc/hosts`
找出domain結尾的行
`awk '/domain[0-9]/' /etc/hosts`

印出欄位1和欄位2，會擠在一塊
`awk '{print $1 $2}' /etc/hosts     `
127.0.0.1localhost
::1localhost

印出欄位1和欄位2，會分開
`awk '{print $1, $2}' /etc/hosts`
127.0.0.1 localhost
::1 localhost

用printf格式化輸出更整齊好看的輸出結果
`awk '{printf "%-20s %s\n", $1, $2}' /etc/hosts`
127.0.0.1            localhost
::1                  localhost

找出$2.多塊錢以上的行，然後用printf加上星號輸出，再找出$0~$1塊錢，printf輸出 ( 可以使用2個pattern+2個action )
`awk '/\$[2-9]\.[0-9][0-9]/ { printf "%-10s %-10s %-10s %-10s\n", $1, $2, $3, $4 "*" ; } /\$[0-1]\.[0-9][0-9]/ { printf "%-10s %-10s %-10s %-10s\n", $1, $2, $3, $4; }' food_prices.list`
1          Mangoes    10         $2.45*
2          Apples     20         $1.50
3          Bananas    5          $0.90
4          Pineapples 10         $3.46*
5          Oranges    10         $0.78
6          Tomatoes   5          $0.55
7          Onions     5          $0.45

或可以改用$0，$0代表一整行，就不用像上面這麼複雜
`awk '/\$[2-9]\.[0-9][0-9]/ { print $0 "*" ; } /\$[0-1]\.[0-9][0-9]/ { print ; }' food_prices.list`
1       Mangoes                    10           $2.45*
2       Apples                     20           $1.50
3       Bananas                    5            $0.90
4       Pineapples                 10           $3.46*
5       Oranges                    10           $0.78
6       Tomatoes                   5            $0.55
7       Onions                     5            $0.45

比較運算子，在數量Quantity大於等於30的最後加上**
`awk '$3 <= 30 {printf "%s\t%s\n", $0, "**"} $3 > 30 {print $0}' food_prices.list`
No      Item_Name               Quantity        Price
1       Mangoes                    45           $3.45
2       Apples                     25           $2.45   **
3       Pineapples                 5            $4.45   **
4       Tomatoes                   25           $3.45   **
5       Onions                     15           $1.45   **
6       Bananas                    30           $3.45   **

或是在數量Quantity小於20的項目，顯示lack缺少
`awk '$3 <= 20 {printf "%s\t%s\n", $0, "lack"} $3 >20 {print $0}' food_prices.list`
No      Item_Name               Quantity        Price
1       Mangoes                    45           $3.45
2       Apples                     25           $2.45
3       Pineapples                 5            $4.45   lack
4       Tomatoes                   25           $3.45
5       Onions                     15           $1.45   lack
6       Bananas                    30           $3.45

組合表達式Compound Expressions
第一個和第二個表達皆須為True，也可以寫and
( first_expression ) && ( second_expression )
兩個有一個為True，也可以寫or
( first_expression ) || ( second_expression) 

價錢$20塊以上，種類為Tech的加上**，~等於匹配運算符號，!~等於不匹配運算符號
`awk '($3 ~ /\$[2-9][0-9]\.[0-9][0-9]$/) && ($4=="Tech") {printf "%s\t%s\n",$0,"*"}' tecmint_deals.txt`

如何使用'next' Command，next方法可以幫助提升運算效率時間，通常用在因前一個表達式已經得到要的答案了，那麼第二個表達式可以跳過，就用next
`awk '$4 <= 20 { printf "%s\t%s\n", $0,"*" ; next; } $4 > 20 { print $0 ;} ' food_list.txt`

只顯示owner為root的檔案
`dir -l | awk '$3=="root" {print $0}'`
-rw-------  1 root   root        1526 Feb 17  2021 anaconda-ks.cfg

cat有Tech的那行，注意使用 tilde波浪~ 匹配字串時，有大小寫區別
cat tecmint_deals.txt | awk '$4 ~ /Tech/'
6       Ditto_Bluetooth_Altering_Device         $33.00          Tech
7       Nano_Prowler_Mini_Drone                 $36.99          Tech


awk變數，在awk指令裡面用變數存output的字串，並print出來
`uname -a | awk '{hostname=$2; print hostname}'`
CentOS_Stream8

awk計算，tecmint.com在檔案出現的次數
`awk '/^tecmint.com/ { counter+=1; printf "%s\n", counter; }' domains.txt`

awk的special pattern : BEGIN 和 END，syntax如下
awk '
 	BEGIN { actions } 
 	/pattern/ { actions }
 	/pattern/ { actions }
            ……….
	 END { actions } 
' filenames
BEGIN pattern : 在任何input行讀取之前BEGIN會被先執行就一次
END pattern   : 在exit離開之前會執行
`awk 'BEGIN {print "The number of times tecmint.com appears in the file is :"} /^tecmint.com/ { counter+=1 ;} END {printf "%s\n", counter}' domains.txt`
The number of times tecmint.com appears in the file is :
6


awk built-in variables awk的內建變數
FILENAME : 現在input的檔案名稱(注意不要更改此變數)
`awk '{ print FILENAME }' ~/domains.txt`

NR       : 顯示檔案的行數
`awk 'END { print "Number of lines in file is : ", NR }' domains.txt`
Number of lines in file is :  14

NF       : number of fields in current input line (do not change variable name)
FS       : awk會將FS指定的欄位運算子劃分，預設的FS是space 和 tab，除了FS外也可以使用-F
`awk -F ':' '{ print $1,$2 }' /etc/passwd`
root x
bin x
`awk 'BEGIN { FS=":" } { print $1,$4 }' /etc/passwd`
root 0
bin 1

OFS      : 輸出欄位分割
`awk -F ':' 'BEGIN { OFS="==>" } { print $1,$2 }' /etc/passwd`
root==>x
bin==>x


RS       : input record separator
ORS      : output record separator


### How to Allow Awk to Use Shell Variables – Part 11
從11這開始看





## -------------------- sed --------------------

## -------------------- RE --------------------
Regular Expression正規表達式
.          單一個任意字元
[abc]      符合a、b、c其中一個字元
[a-c]      符合a-c其中一個字元 (可用hyphen連字號-代表)
[^a-c]     不符合a-c其中一個字元
^A         符合A開頭的字
$          符合結尾的字
\          跳脫字元
*          0個或多個前面的字元
\+         1個或多個前面的字元

好用指令
grep -v "^&" file.txt             過濾空白行



