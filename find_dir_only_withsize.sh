#!/bin/sh
########## find directory name on the basis of size########
mkdir onlydir_name
> onlydir_name/dir_100gb.csv
> onlydir_name/dir_200gb.csv
> onlydir_name/dir_300gb.csv
> onlydir_name/dir_400gb.csv
> onlydir_name/dir_500gb.csv
> onlydir_name/dir_600gb.csv
> onlydir_name/dir_700gb.csv
> onlydir_name/dir_800gb.csv
> onlydir_name/dir_900gb.csv
> onlydir_name/dir_1000gb.csv

echo "Storing file that are in more than 100GBs"
cat final_dir_name_file.csv | awk  -F' ' '{ if ( $1 >= '10000' ) {print $0}}' >> onlydir_name/dir_100gb.csv
#cat final_dir_name_file.csv | awk  -F' ' '{ if ( $1 >= '107374182400' ) {print $0}}' >> dir_100gb.csv

echo "Storing file that are in more than 200GBs"
cat final_dir_name_file.csv | awk  -F' ' '{ if ( $1 >= '214748364800' ) {print $0}}' >> onlydir_name/dir_200gb.csv

echo "Storing file that are in more than 300GBs"
cat final_dir_name_file.csv | awk  -F' ' '{ if ( $1 >= '322122547200' ) {print $0}}' >> onlydir_name/dir_300gb.csv

echo "Storing file that are in more than 400GBs"
cat final_dir_name_file.csv | awk  -F' ' '{ if ( $1 >= '429496729600' ) {print $0}}' >> onlydir_name/dir_400gb.csv

echo "Storing file that are in more than 500GBs"
cat final_dir_name_file.csv | awk  -F' ' '{ if ( $1 >= '536870912000' ) {print $0}}' >> onlydir_name/dir_500gb.csv

echo "Storing file that are in more than 600GBs"
cat final_dir_name_file.csv | awk  -F' ' '{ if ( $1 >= '644245094400' ) {print $0}}' >> onlydir_name/dir_600gb.csv

echo "Storing file that are in more than 700GBs"
cat final_dir_name_file.csv | awk  -F' ' '{ if ( $1 >= '751619276800' ) {print $0}}' >> onlydir_name/dir_700gb.csv

echo "Storing file that are in more than 800GBs"
cat final_dir_name_file.csv | awk  -F' ' '{ if ( $1 >= '858993459200' ) {print $0}}' >> onlydir_name/dir_800gb.csv

echo "Storing file that are in more than 900GBs"
cat final_dir_name_file.csv | awk  -F' ' '{ if ( $1 >= '966367641600' ) {print $0}}' >> onlydir_name/dir_900gb.csv

echo "Storing file that are in more than 1000GBs"
cat final_dir_name_file.csv | awk  -F' ' '{ if ( $1 >= '1073741824000' ) {print $0}}' >> onlydir_name/dir_1000gb.csv
########## End find directory name on the basis of size########
