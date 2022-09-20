#!/bin/sh

START_DT=1
END_DT=1
TARGT_LOCATION="/var/log/"
#DESTINATION="/root/Downloads/ga4k-main"

echo "Total size: $(du -sh $TARGT_LOCATION)"

find /var/log/ -type f -mtime +1 -print0 | xargs -0 ls -l --time-style="+%Y-%m-%d" | awk -F' ' '{print $6" "$5" "$7 }' | sort -n  > data_output_file

echo "Less than 6 month"
perl -ne 'if ( m/^([0-9-]+)/ ) { $date = $1; print if ( $date ge "2022-03-21" and $date le "2022-09-21" ) }' data_output_file | awk -F' ' '{print $2 }' | awk '{s+=$1}END{print s}' | awk '{print int($1/1000/1000)}'

echo "6 month to 1 year"
perl -ne 'if ( m/^([0-9-]+)/ ) { $date = $1; print if ( $date ge "2021-09-21" and $date le "2022-03-21" ) }' data_output_file | awk -F' ' '{print $2 }' | awk '{s+=$1}END{print s}' | awk '{print int($1/1000/1000)}'

echo "1-2 years"
perl -ne 'if ( m/^([0-9-]+)/ ) { $date = $1; print if ( $date ge "2020-09-21" and $date le "2021-09-21" ) }' data_output_file | awk -F' ' '{print $2 }' | awk '{s+=$1}END{print s}' | awk '{print int($1/1000/1000)}'

echo "2-3 years"
perl -ne 'if ( m/^([0-9-]+)/ ) { $date = $1; print if ( $date ge "2019-09-21" and $date le "2020-09-21" ) }' data_output_file | awk -F' ' '{print $2 }' | awk '{s+=$1}END{print s}' | awk '{print int($1/1000/1000)}'


echo "3-5 years"
perl -ne 'if ( m/^([0-9-]+)/ ) { $date = $1; print if ( $date ge "2017-09-21" and $date le "2019-09-21" ) }' data_output_file | awk -F' ' '{print $2 }' | awk '{s+=$1}END{print s}' | awk '{print int($1/1000/1000)}'

echo "Greater than 5 years"
perl -ne 'if ( m/^([0-9-]+)/ ) { $date = $1; print if ( $date ge "2000-01-10" and $date le "2017-09-21" ) }' data_output_file | awk -F' ' '{print $2 }' | awk '{s+=$1}END{print s}' | awk '{print int($1/1024/1024)}'




#'{ MB = int($2/1024/1024); print $1 " " MB; if (MB > 1024) print $1 " value in critical"}' 



