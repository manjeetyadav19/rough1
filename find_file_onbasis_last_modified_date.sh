#!/bin/sh

DAYS=1
LOCATION="/var/log/"
>total_file_list.csv
>total_old_file.csv


# file list on the basis of last modifed date
find $LOCATION -type f -mtime +$DAYS -print0 | xargs -0 ls -l --time-style="+%Y-%m-%d" | awk -F' ' '{print $6" "$7}' | sort -n > total_old_file.csv

#finding file size and storing in total_fil_list.csv
while read line
do
  TEMP=$(echo $line | awk -F' ' '{print $2}')
  ls -al --time-style="+%Y-%m-%d" $TEMP | awk -F' ' '{print $6" "$5" "$7}' >> total_file_list.csv
done < total_old_file.csv

# count total file list
echo
echo "Total file find on the location   : $(cat total_old_file.csv | awk -F' ' '{print $2}' | wc -l)"
echo

