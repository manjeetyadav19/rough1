#!/bin/sh

DAYS=1
TARGT_LOCATION="/var/log/"
DESTINATION="/root/Downloads/ga4k-main"


#Find greater than 5MB and we also print its relevant file size:
#find $TARGT_LOCATION -size +5M -exec ls -sh {} +


#Find first 3 largest files located in a LOCATION directory recursively:
#find $TARGT_LOCATION -type f -exec ls -s {} + | sort -n -r | head -3

#---------------------------------------------

#find a file older than 30 days with last modified date and in sorted format
#find $PATH -maxdepth 1 -type f -mtime +$DAYS  -printf "%-${3:-40}p %TY-%Tm-%Td\n"
#find $TARGT_LOCATION -maxdepth 1 -type f -mtime +30  -printf "%-${3:-40}p %TY-%Tm-%Td\n" | sed -E 's|^$(LOCATION)||' | sort -s -k 2.1,2.4 -k 2.6,2.7 -k 2.9,2.10 -k2.10

# find a file older than 30 days  maxdepth 1 and sorted on the basis of file size
#find $TARGT_LOCATION -maxdepth 1 -type f -mtime +30 -exec ls -sh {} + | sort -r -n

#----------------------------

#find all files older than 30 days with last modified date and in sorted format
#find $TARGT_LOCATION -type f -mtime +30  -printf "%-${3:-40}p %TY-%Tm-%Td\n" | sed -E 's|^$(LOCATION)||' | sort -s -k 2.1,2.4 -k 2.6,2.7 -k 2.9,2.10 -k2.10

# find all files older than 30 days and sorted on the basis of file size
#find $TARGT_LOCATION -type f -mtime +30 -exec ls -sh {} + | sort -r -n


# file list on the basis of last modifed date
find $TARGT_LOCATION -type f -mtime +$DAYS -print0 | xargs -0 ls -l --time-style="+%Y-%m-%d" | awk -F' ' '{print $6" "$7}' | sort -n > total_old_file.csv

# file list aft. excl. of certain files type
find $TARGT_LOCATION -not \( -name '*.log' -o -name '*.log.*' -o -name '*.txt' \) -type f -mtime +$DAYS -print0 | xargs -0 ls -l --time-style="+%Y-%m-%d" | awk -F' ' '{print $6" "$7}' | sort -n > list_aft_excl.csv

# excl. files list
find $TARGT_LOCATION \( -name '*.log' -o -name '*.log.*' -o -name '*.txt' \) -type f -mtime +$DAYS -print0 | xargs -0 ls -l --time-style="+%Y-%m-%d" | awk -F' ' '{print $6" "$7}' | sort -n > excl_file.csv


# count total files/ files aft. excl. and exclded. file list
echo
echo "Total files   : $(cat total_old_file.csv | awk -F' ' '{print $2}' | wc -l)"
echo "File aft excl.: $(cat list_aft_excl.csv | awk -F' ' '{print $2}' | wc -l)"
echo "Excld. files  : $(cat excl_file.csv | awk -F' ' '{print $2}' | wc -l)"
echo

echo "Total files list   : $(pwd)/total_old_file.csv"
echo "Fils aft. excl. lst: $(pwd)/list_aft_excl.csv"
echo "Exclded. fils lst  : $(pwd)/excl_file.csv"
echo

# Copy files on the Destination location
#cat list_aft_excl.csv | awk -F' ' '{print $2}' | cpio -pvdumB $DESTINATION
#xargs -n 1 cp -v ./Archive/$TARGT_LOCATION


