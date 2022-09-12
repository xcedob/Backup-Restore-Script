#! /bin/bash

echo "
              __  __          ____           _                                   _       _   _
             |  \/  |_   _   |  _ \ ___  ___| |_ ___  _ __ ___     ___  ___ _ __(_)_ __ | |_| |
             | |\/| | | | |  | |_) / _ \/ __| __/ _ \| '__/ _ \   / __|/ __| '__| | '_ \| __| |
             | |  | | |_| |  |  _ <  __/\__ \ || (_) | | |  __/   \__ \ (__| |  | | |_) | |_|_|
             |_|  |_|\__, |  |_| \_\___||___/\__\___/|_|  \___|   |___/\___|_|  |_| .__/ \__(_)
                      |___|                                                       |_|

"
echo -n "[!] Enter directory: "
read DIRECTORY

#Convert Windows dir path to Linux dir path
DIR_SPLIT=$(echo $DIRECTORY | awk  -F: '{print substr($2,0),$3}')
if [[ $DIR_SPLIT == *"pg-backup-"* ]];
then
    DIR_SHL=$(echo $DIR_SPLIT | awk -F"backup" '{print "pg-backup" $3}')
else
    DIR_SHL=$(echo $DIR_SPLIT | awk -F"backup" '{print $2}')
fi
NAMEDB=$(echo "$DIR_SPLIT" | sed 's/backup.*//')
BKDATE=$(echo "$DIR_SHL" | awk -F"pg_data" '{print $1}')
BACKUP_DATE=(${BKDATE//2022//2022})
DIR="/mnt/d/$NAMEDB/backup/$BACKUP_DATE/pg_data"
if [[ ! -d "$DIR" ]]
then
    echo "[!] ERR: Directory by [path=$DIR] DOES NOT exists."
    exit 9999
fi
cd $DIR
echo "
[xxx]  Target directory is [$DIR]: do gunzip all .gz  [xxx]


"
#unzip all .gz files
for f in *.gz; do gunzip -c "$f">./"${f%.*}"; done
echo "[*.gz]  #######################   [100%]"
for f in */*.gz; do gunzip -c "$f">./"${f%.*}"; done
echo "[*/*.gz] #######################   [100%]"
for f in */*/*.gz; do gunzip -c "$f">./"${f%.*}"; done
echo "[*/*/*.gz] #######################  [100%]


"
echo "[+] All files .gz unziped! [+]"
echo -n "[!] Enter version of Postgresql database: "
read VERSION
DATA="data_directory = '$DIR'"
case $VERSION in
        14 ) sed -i -e "s@^data_directory =.*@$DATA@" /etc/postgresql/14/main/postgresql.conf;;
        12 ) sed -i -e "s@^data_directory =.*@$DATA@" /etc/postgresql/12/main/postgresql.conf;;
        11 ) sed -i -e "s@^data_directory =.*@$DATA@" /etc/postgresql/11/main/postgresql.conf;;
        10 ) sed -i -e "s@^data_directory =.*@$DATA@" /etc/postgresql/10/main/postgresql.conf;;
        * ) echo "Oh nooo, we dont have this verison of postgresql! call your DevOps" && exit 9999;;
esac
echo "
[%] OKay we setup your db, lets run it! [%]

"
sleep 2
/etc/init.d/postgresql start $VERSION
sleep 2
pg_lsclusters
echo -n "

[!]Be careful type anything and we will end work! [!]"
read UN
echo -n "Another one!"
read UNB
/etc/init.d/postgresql stop $VERSION
sleep 2
find -type f -not -name '*.gz' -delete
echo "
              Bye!

⠄⠄⠄⠄⠄⠄⠄⠄⣸⣿⣿⠁⠄⠄⢀⡀⠄⠄⠈⣿⣿⣇⠄⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠄⠄⠄⢻⣿⣷⢀⣠⣶⣿⣿⣶⣄⡀⣾⣿⡟⠄⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠄⠄⣀⡈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢁⣀⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠐⠶⣿⣿⣿⣿⣌⠻⣿⣿⣿⣿⣿⣿⣿⣿⠟⣡⣿⣿⣿⣿⠶⠂⠄⠄⠄
⠄⠄⠄⠄⠄⣦⡬⢙⠛⠿⣷⣿⣿⣿⣿⣿⣿⣿⣿⣾⠿⠛⡋⢥⣴⠄⠄⠄⠄⠄
⠄⠄⠄⠄⢠⣿⣇⢸⣿⣷⣦⣍⠻⣿⣿⣿⣿⠟⣩⣴⢾⣿⡇⣸⣿⡄⠄⠄⠄⠄
⠄⠄⠄⢀⣾⣿⣿⢸⣿⣟⠻⣿⣷⣦⡹⢏⣴⣾⣿⠏⢻⣿⡇⣿⣿⣷⡀⠄⠄⠄
⠄⠄⣠⣾⣿⣿⣿⢸⣿⣿⢀⡀⠹⣿⣷⣿⣿⠏⠵⣚⣾⣿⡇⣿⣿⣿⣷⣄⠄⠄
⢴⣾⣿⣿⣿⣿⣿⡈⣿⣿⡸⣿⣷⣶⣶⣶⣶⣖⣾⣿⣿⣿⢁⣿⣿⣿⣿⣿⣷⡦
⠈⢻⣿⣿⣿⣿⣿⣧⠸⣿⣧⡉⢻⣿⣿⣿⣿⡟⠋⣩⣥⠆⣼⣿⣿⣿⣿⣿⡟⠁
⠄⠄⠙⣿⣿⣿⣿⣿⣧⡙⣿⣷⣼⣿⣿⣿⣿⣧⣾⣿⢋⣼⣿⣿⣿⣿⣿⠋⠄⠄
⠄⠄⠄⠈⠻⣿⣿⣿⣿⣷⣌⠻⣿⣿⡟⣿⣿⣿⡿⣡⣾⣿⣿⣿⣿⠟⠁⠄⠄⠄
⠄⠄⠄⠄⠄⠈⠻⡿⠃⣿⣿⣷⣌⠻⡇⣿⠟⣩⣾⣿⣿⠘⢿⠟⠁⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠄⠄⠄⠄⠈⠻⣿⣿⣷⣦⣴⣾⣿⣿⠟⠁⠄⠄⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢈⣽⣿⣿⣿⣿⣯⡁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
"