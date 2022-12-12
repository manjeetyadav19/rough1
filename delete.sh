#!/bin/sh

current_time=$(date "+%Y%m%d_%H%M%S")
SNO=1


current_time_1="20221130_123104"
mkdir ../log/$current_time_1/del_log_$current_time 2> /dev/null
LOG_FILE="../log/$current_time_1/del_log_$current_time/log_$current_time"


exec 1> ../log/$current_time_1/del_log_$current_time/Console_Error_del_$current_time 2>&1

logit() 
{
    echo "[`date`] - ${*}" >> ${LOG_FILE}
}

       #deleting files
       logit "********deleting start**********"
       while read line
       do 
       S_FSIZE=$(echo $line | awk -F' ' '{print $2 }')
       S_FNAME=$(echo $line | awk -F' ' '{print $3 }')


       rm $S_FNAME 2> ../log/$current_time_1/del_log_$current_time/Failed_to_Delete_$current_time_$SNO

	EXIT_CODE=$(echo $?)
	if [ $EXIT_CODE -eq "0" ]; 
	then 
	    logit "$CMD File Deleted Succesfully"
	    logit " File name: $S_FNAME"
            logit
	    echo "$S_FNAME" >> ../log/$current_time_1/del_log_$current_time/Succesfull_Deleted_Filelist_$current_time_$SNO
            ((Success_count=Success_count+1))
	else 
	    logit "$CMD !!!unsuccessfully!!! File Failed to delete"
	    logit " File name: $S_FNAME" 
	    logit " Error in delete: $(cat ../log/$current_time_1/del_log_$current_time/Failed_to_Delete_$current_time_$SNO)"
	    echo "$S_FNAME" >> ../log/$current_time_1/del_log_$current_time/Failed_to_Delete_Filelist_$current_time_$SNO
	    logit  
            ((Failed_count=Failed_count+1))
	fi
       done < ../log/$current_time_1/list_aft_excl_1.csv       

   
       logit "********Deletion Finished for location **********" 
       logit 
       logit
       logit "********Report for Deletion file for location **********"
       logit "Total File Succesfully Deleted : $Success_count"
       echo "Total File Succesfully Deleted : $Success_count" >> ../log/$current_time_1/del_log_$current_time/Summary_del_$current_time_$SNO.txt
       logit "Failed Count : $Failed_count"
       echo "Failed Count : $Failed_count" >> ../log/$current_time_1/del_log_$current_time/Summary_del_$current_time_$SNO.txt
       SPACE_CALC=$(sh size_calc.sh ../log/$current_time_1/del_log_$current_time/list_aft_excl_$current_time_$SNO.csv)
       #logit "Total space saved : ${SPACE_CALC}MB" 
       #echo "Total space saved : ${SPACE_CALC}MB" >> ../log/$current_time_1/del_log_$current_time/Summary_del_$current_time_$SNO.txt
       logit
       logit
