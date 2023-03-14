#!/bin/sh
today=`date +'%s'`
PATH_NAME=""
DAYS=""
> hadoop_data

hdfs dfs -ls -R / | grep "^-" | while read line ; do
dir_date=$(echo ${line} | awk '{print $6}')
difference=$(( ( ${today} - $(date -d ${dir_date} +%s) ) / ( 24*60*60 ) ))
filePath=$(echo ${line} | awk '{print $8}')

if [ ${difference} -gt 0 ]; then
    hdfs dfs -ls $filePath | awk '{print $6,$8}' >> hadoop_data
fi
done

