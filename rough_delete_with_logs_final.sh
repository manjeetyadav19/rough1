#!/bin/sh

current_time=$(date "+%Y%m%d_%H%M%S")
SNO=1
db="../../example.db"
table="copied_file"
PATH1="/root/Downloads/ga4k-main/Cleanup_package_V5.0"

LOG_FILE="../log/$current_time/log_$current_time"

mkdir ../log/$current_time 2> /dev/null
exec 1> ../log/$current_time/Console_Error$current_time 2>&1

logit() 
{
    echo "[`date`] - ${*}" >> ${LOG_FILE}
}

cat ../config/cleanup.config | while read line
do 
   if [[ $line == DAYS* ]];
   then
       Failed_count=0
       Success_count=0
       DAYS=$(echo $line | awk 'BEGIN { FS="," }  {print $1 }' | awk -F= '{print $2}' | sed 's/ //g' | sed -e 's/^"//' -e 's/"$//') 
       TARGT_LOCATION=$(echo $line | awk 'BEGIN { FS="," }  {print $2 }' | awk -F= '{print $2}' | sed 's/ //g' | sed -e 's/^"//' -e 's/"$//')
       #TARGT_LOCATION=$(echo $line | awk 'BEGIN { FS="," } /1/  {print $2 }' | awk -F= '{print $2}' | set -e /\//_/ )
       DESTINATION=$(echo $line | awk 'BEGIN { FS="," } {print $3 }' | awk -F= '{print $2}' | sed 's/ //g' | sed -e 's/^"//' -e 's/"$//')
       TO_EMAIL=$(echo $line | awk 'BEGIN { FS="," } {print $4 }' | awk -F= '{print $2}' | sed 's/ //g' | sed -e 's/^"//' -e 's/"$//')
       
       #mkdir ../log/$current_time 2> /dev/null
       # file list on the basis of last modifed date
       CHECK=$(find $TARGT_LOCATION -type f -mtime +$DAYS -print0 | awk 'END { print (NR > 0 && NF > 0) ? "Not empty" : "Empty"}')
       if [[ "$CHECK" == "Empty" ]];
       then 
	    touch ../log/$current_time/total_old_file_$current_time_$SNO.csv
       else
            find $TARGT_LOCATION -type f -mtime +$DAYS -print0 | xargs -0 ls -l --time-style="+%Y-%m-%d" | awk -F' ' '{print $6" "$5" "$7 }' | sort -n > ../log/$current_time/total_old_file_$current_time_$SNO.csv 
       fi


       #file list aft. excl. of certain files type
       CHECK=$(find $TARGT_LOCATION -not \( -name '*.log' -o -name '*.log.*' -o -name '*.txt' \) -type f -mtime +$DAYS -print0 | awk 'END { print (NR > 0 && NF > 0) ? "Not empty" : "Empty"}')
       if [[ "$CHECK" == "Empty" ]];
       then 
            touch ../log/$current_time/list_aft_excl_$current_time_$SNO.csv
       else
            find $TARGT_LOCATION -not \( -name '*.log' -o -name '*.log.*' -o -name '*.txt' \) -type f -mtime +$DAYS -print0 | xargs -0 ls -l --time-style="+%Y-%m-%d" | awk -F' ' '{print $6" "$5" "$7 }' | sort -n > ../log/$current_time/list_aft_excl_$current_time_$SNO.csv
       fi
      

       # excl. files list
       CHECK=$(find $TARGT_LOCATION \( -name '*.log' -o -name '*.log.*' -o -name '*.txt' \) -type f -mtime +$DAYS -print0 | awk 'END { print (NR > 0 && NF > 0) ? "Not empty" : "Empty"}') 
       if [[ "$CHECK" == "Empty" ]];
       then 
	    touch ../log/$current_time/excl_file_$current_time_$SNO.csv
       else
            find $TARGT_LOCATION \( -name '*.log' -o -name '*.log.*' -o -name '*.txt' \) -type f -mtime +$DAYS -print0 | xargs -0 ls -l --time-style="+%Y-%m-%d" | awk -F' ' '{print $6" "$5" "$7 }' | sort -n > ../log/$current_time/excl_file_$current_time_$SNO.csv 
       fi
       

       
       while read line
       do 
       S_FSIZE=$(echo $line | awk -F' ' '{print $2 }')
       S_FNAME=$(echo $line | awk -F' ' '{print $3 }')
       TEMP=$(ls -l $DESTINATION$S_FNAME  2>> ../log/$current_time/actual_file_need_to_copy_$current_time_$SNO.csv | awk -F' ' '{print $2 }')
 
       if [[ "$TEMP" == "1" ]];
       then 
	    ls -l $DESTINATION$S_FNAME | awk -F' ' '{print $9 }' >> ../log/$current_time/Duplicate_files_$current_time_$SNO.csv
	    D_FSIZE=$(ls -l $DESTINATION$S_FNAME | awk -F' ' '{print $5 }')

	    if [[ "$D_FSIZE" != "$S_FSIZE" ]];
	    then 
	 	logit "Different file"
		logit "File_name: $S_FNAME Dest_Size:$D_FSIZE Source_Size:$S_FSIZE"
		ls -l $DESTINATION$S_FNAME | awk -F' ' '{print $9 }' >> ../log/$current_time/Duplicate_diff_files_$current_time_$SNO
	    fi
       fi
       done < ../log/$current_time/list_aft_excl_$current_time_$SNO.csv
   

       logit "********Analysis for $TARGT_LOCATION location**********"
       logit "Total files         : $(cat ../log/$current_time/total_old_file_$current_time_$SNO.csv | wc -l )"
       echo "Total files         : $(cat ../log/$current_time/total_old_file_$current_time_$SNO.csv | wc -l )" >> ../log/$current_time/Summary_$current_time_$SNO.txt
       logit "Excld. files        : $(cat ../log/$current_time/excl_file_$current_time_$SNO.csv | wc -l)"
#       echo "Excld. files        : $(cat ../log/$current_time/excl_file_$current_time_$SNO.csv | wc -l)" >> ../log/$current_time/Summary_$current_time_$SNO.txt
       logit "File aft excl.      : $(cat ../log/$current_time/list_aft_excl_$current_time_$SNO.csv | wc -l)"
#       echo "File aft excl.      : $(cat ../log/$current_time/list_aft_excl_$current_time_$SNO.csv | wc -l)"  >> ../log/$current_time/Summary_$current_time_$SNO.txt
       logit "Dupl. fils lst      : $(cat ../log/$current_time/Duplicate_files_$current_time_$SNO.csv | wc -l)"
#       echo "Dupl. fils lst      : $(cat ../log/$current_time/Duplicate_files_$current_time_$SNO.csv | wc -l)" >> ../log/$current_time/Summary_$current_time_$SNO.txt
       logit "Actl. fils lst      : $(cat ../log/$current_time/actual_file_need_to_copy_$current_time_$SNO.csv | wc -l)"
#       echo "Actl. fils lst      : $(cat ../log/$current_time/actual_file_need_to_copy_$current_time_$SNO.csv | wc -l)" >> ../log/$current_time/Summary_$current_time_$SNO.txt
       logit "Dupl_diff_sz fls lst: $(cat ../log/$current_time/Duplicate_diff_files_$current_time_$SNO.csv | wc -l)"
#       echo "Dupl_diff_sz fls lst: $(cat ../log/$current_time/Duplicate_diff_files_$current_time_$SNO.csv | wc -l)" >> ../log/$current_time/Summary_$current_time_$SNO.txt
       SPACE_CALC=$(sh size_calc.sh ../log/$current_time/list_aft_excl_$current_time_$SNO.csv)
       logit "Total Space could be save : ${SPACE_CALC}MB" 
       echo "Total Space could be save : ${SPACE_CALC}MB" >> ../log/$current_time/Summary_$current_time_$SNO.txt
       logit
       echo >> ../log/$current_time/Summary_$current_time_$SNO.txt

       # output location for Total files, files aft. excl. and exclded fils list
       logit "For location: $TARGT_LOCATION"
       logit "Total files list    : $PATH1log/$current_time/total_old_file_$current_time_$SNO.csv"
       echo "Total files list    : $PATH1/log/$current_time/total_old_file_$current_time_$SNO.csv" >> ../log/$current_time/Summary_$current_time_$SNO.txt
       logit "Fils aft. excl. lst : $PATH1/log/$current_time/list_aft_excl_$current_time_$SNO.csv"
#       echo "Fils aft. excl. lst : $PATH1/log/$current_time/list_aft_excl_$current_time_$SNO.csv" >> ../log/$current_time/Summary_$current_time_$SNO.txt
       logit "Exclded. fils lst   : $PATH1/log/$current_time/excl_file_$current_time_$SNO.csv"
#       echo "Exclded. fils lst   : $PATH1/log/$current_time/excl_file_$current_time_$SNO.csv" >> ../log/$current_time/Summary_$current_time_$SNO.txt
       logit "Actl. fils lst      : $PATH1/log/$current_time/actual_file_need_to_copy_$current_time_$SNO.csv"
#       echo "Actl. fils lst      : $PATH1/log/$current_time/actual_file_need_to_copy_$current_time_$SNO.csv" >> ../log/$current_time/Summary_$current_time_$SNO.txt
       logit "Dupl. fils lst:     : $PATH1/log/$current_time/Duplicate_files_$current_time_$SNO.csv"
#       echo "Dupl. fils lst:     : $PATH1/log/$current_time/Duplicate_files_$current_time_$SNO.csv" >> ../log/$current_time/Summary_$current_time_$SNO.txt
       logit "Dupl_diffsz fls lst : $PATH1/log/$current_time/Duplicate_diff_files_$current_time_$SNO.csv"
#       echo "Dupl_diffsz fls lst : $PATH1/log/$current_time/Duplicate_diff_files_$current_time_$SNO.csv" >> ../log/$current_time/Summary_$current_time_$SNO.txt
       logit
       echo  >> $PATH1/log/$current_time/Summary_$current_time_$SNO.txt
   

       #copying files
       logit "********Copying Start**********"
       while read line
       do 
       S_FSIZE=$(echo $line | awk -F' ' '{print $2 }')
       S_FNAME=$(echo $line | awk -F' ' '{print $3 }')
       #S_FNAME=$(echo $line | awk -F' ' '{print $3 }' > ../log/20220926/S_FNAME_TEMP)
       #logit "File name:$S_FNAME" 
       #logit "File Size:$DESTINATION"

       cp -p --parents $S_FNAME $DESTINATION 2> ../log/$current_time/Failed_to_Copy_$current_time_$SNO.csv
       #cp -p --parents $(cat ../log/20220926/S_FNAME_TEMP) $DESTINATION
       #cat ../log/20220926/TEMP_1 | cpio -pvdumB "$DESTINATION"
	EXIT_CODE=$(echo $?)
        STRING=$(cat ../log/$current_time/Failed_to_Copy_$current_time_$SNO.csv)
	if [ $EXIT_CODE -eq "0" ]; 
	then 
	    logit "$CMD File Copied Succesfully"
	    logit " File name: $S_FNAME"
            logit " Dest Path: $DESTINATION$S_FNAME" 
	    echo "$S_FNAME" >> ../log/$current_time/Succesfull_Copied_Filelist_$current_time_$SNO.csv
            D_FSIZE=$(ls -l $DESTINATION$S_FNAME | awk -F' ' '{print $5 }')

            sqlite3 "$db" "INSERT INTO $table VALUES ('$current_time','$S_FNAME','$DESTINATION$S_FNAME','$S_FSIZE','$D_FSIZE')";

	    if [[ "$D_FSIZE" == "$S_FSIZE" ]];
	    then 
		logit " Sizes Matched - Dest_Size:$D_FSIZE Source_Size:$S_FSIZE"
                logit
                ((Success_count=Success_count+1))
	    fi
        elif [ $EXIT_CODE -eq "1" ];
	then
            if [[ $STRING == *"cp failed to preserve times"* ]]; 
            then
               logit "$CMD File Copied Succesfully"
   	       logit " File name: $S_FNAME" 
  	       logit " Error during copy: $(cat ../log/$current_time/Failed_to_Copy_$current_time_$SNO.csv)"
	       echo "$S_FNAME" >> ../log/$current_time/Failed_to_Copy_Filelist_$current_time_$SNO.csv
               D_FSIZE=$(ls -l $DESTINATION$S_FNAME | awk -F' ' '{print $5 }')

               sqlite3 "$db" "INSERT INTO $table VALUES ('$current_time','$S_FNAME','$DESTINATION$S_FNAME','$S_FSIZE','$D_FSIZE')";               

	       if [[ "$D_FSIZE" == "$S_FSIZE" ]];
	       then 
		  logit " Sizes Matched - Dest_Size:$D_FSIZE Source_Size:$S_FSIZE"
                  logit
                  ((Success_count=Success_count+1))
	       fi 
	    else
	       logit "$CMD !!!unsuccessfully!!! File Failed to copy"
	       logit " File name: $S_FNAME" 
	       logit " Error in copy: $(cat ../log/$current_time/Failed_to_Copy_$current_time_$SNO.csv)"
	       echo "$S_FNAME" >> ../log/$current_time/Failed_to_Copy_Filelist_$current_time_$SNO.csv
	       logit  
               ((Failed_count=Failed_count+1))
	    fi
	else 
	    logit "$CMD !!!unsuccessfully!!! File Failed to copy"
	    logit " File name: $S_FNAME" 
	    logit " Error in copy: $(cat ../log/$current_time/Failed_to_Copy_$current_time_$SNO.csv)"
	    echo "$S_FNAME" >> ../log/$current_time/Failed_to_Copy_Filelist_$current_time_$SNO.csv
	    logit  
            ((Failed_count=Failed_count+1))
	fi
       done < ../log/$current_time/list_aft_excl_$current_time_$SNO.csv        

   
       logit "********Copying Finished for location $TARGT_LOCATION**********" 
       logit 
       logit
       logit "********Report for Copied file for location $TARGT_LOCATION**********"
       logit "Total File Succesfully Copied : $Success_count"
       echo "Total File Succesfully Copied : $Success_count" >> ../log/$current_time/Summary_$current_time_$SNO.txt
       logit "Failed Count : $Failed_count"
       echo "Failed Count : $Failed_count" >> ../log/$current_time/Summary_$current_time_$SNO.txt
       echo >> ../log/$current_time/Summary_$current_time_$SNO.txt
       echo "Below is the list for Succesfully Copied, Please reach to infra team for deletion of files from source location." >> ../log/$current_time/Summary_$current_time_$SNO.txt
       echo "Total File Succesfully Copied List: $PATH1/log/$current_time/Succesfull_Copied_Filelist_$current_time_$SNO.csv" >> ../log/$current_time/Summary_$current_time_$SNO.txt
       echo >> ../log/$current_time/Summary_$current_time_$SNO.txt
       echo "Total File Failed to Copied List:  $PATH1/log/$current_time/Failed_to_Copy_Filelist_$current_time_$SNO.csv" >> ../log/$current_time/Summary_$current_time_$SNO.txt
       SPACE_CALC=$(sh size_calc.sh ../log/$current_time/list_aft_excl_$current_time_$SNO.csv)
       echo >> ../log/$current_time/Summary_$current_time_$SNO.txt
       logit "Total space saved : ${SPACE_CALC}MB" 
       echo "Total space saved : ${SPACE_CALC}MB" >> ../log/$current_time/Summary_$current_time_$SNO.txt
       logit
       logit

       
       logit "********Sending Email about all Report for location $TARGT_LOCATION**********"
       echo -e "Hello there\n \nThis is the automated email from Metics Hot Storage regarding Archiving.\n\nPlease find the Attachment for Summary. \nFor more detail you can ping or reach to:\n Manjeet.Yadav1@aexp.com\n" | mailx -s "Automated Summary Regarding Helios/Metics Archiving" -a ../log/$current_time/Summary_$current_time_$SNO.txt $TO_EMAIL
       EXIT_CODE=$(echo $?)
	if [ $EXIT_CODE -eq "0" ]; 
	then 
	    logit "$CMD Email Sent Succesfully to $TO_EMAIL"
	    logit 
	else 
	    logit "$CMD !!!unsuccessfully!!! Failed to Send mail"
	    logit  
	fi


       # Copy files on the Destination location
       #cat ../log/$current_time/list_aft_excl_$current_time_$SNO.csv | awk -F' ' '{print $2}' | cpio -pvdumB $DESTINATION:q
       #cat ../log/$current_time/list_aft_excl_$current_time_$SNO.csv | while read line
       #do 
       #  Source_FSIZE=$(echo $line | awk 'BEGIN { FS="," } /1/  {print $1 }' | awk -F= '{print $2}' | sed 's/ //g' | sed -e 's/^"//' -e 's/"$//')
       #  Dest_FSIZE=$(ls )
       #  if [[ $line == DAYS* ]];
       #  then 
       #xargs -n 1 cp -v $DESTINATION$TARGT_LOCATION 
       ((SNO=SNO+1))
   fi
done
