find /var/log -type d -mindepth 2 -mtime +1 -print0 | xargs -0 ls -l  > data_output_file
#| awk -F' ' '{print $6" "$5" "$7 }' | sort -n > data_output_file

> data_output_file1
while read line
do 
   if [[ $line == /var/log* ]];
   then
       TEMP=$(echo $line | sed -e 's/:$//')
       echo $TEMP >> data_output_file1
   fi
        
done < data_output_file


while read line
do 
 du -s --block-size=1 $line
        
done < data_output_file1
