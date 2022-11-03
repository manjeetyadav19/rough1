#!/bin/sh
>output
>output1
>jsondatanew
>jsondatanew.csv

ls /root/springboot > output

while read line
do 
  echo "$(pwd)/$line" >> output1
done < output

echo "ID,TYPE,NAME" >> jsondatanew.csv

while read line
do 
  #maprcli $line > jsondata
  temp_var=$(sed -n '2p' jsondata | awk 'BEGIN { FS=": " }  {print $2 }' | sed -e 's/^"//' -e 's/,$//' | sed 's/"$//')
  temp_var1=$(sed -n '3p' jsondata | awk 'BEGIN { FS=": " }  {print $2 }' | sed -e 's/^"//' -e 's/,$//' | sed 's/"$//')
  temp_var2=$(sed -n '4p' jsondata | awk 'BEGIN { FS=": " }  {print $2 }' | sed -e 's/^"//' -e 's/,$//' | sed 's/"$//')
  echo "$temp_var,$temp_var1,$temp_var2" >> jsondatanew.csv
done < output1
