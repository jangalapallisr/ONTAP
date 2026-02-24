#!/bin/bash
#set -x
################################################################################################################################################################################################
#Script Name:   SnapMirror_ONTAP2FSxN.sh
#Author:        Subbu Jangalapalli
#Date:          02/24/2026
###Description:   This script is for to:
#########################1. Create SnapMirror Relationship
##########################2. Initialize SnapMirror Relationship
###########################3. Update SnapMirror Relationship (Incremental Updates)
############################4. Check SnapMirror Status
#############################5. Schedule SnapMirror Updates
#
#Usage:     	<Script Name > <arg1> //arg1 is test or prod env;
#Examle:    	./SnapMirror_ONTAP2FSxN.sh  <test>
#
# Change History:
#----------------------------------------------------------------------------------------------------------------------------
#Date            	  Name/ID              Change Description with reference Ticket number
#02/24/2026        	Subbuj               Initial Creation of the script
#
##################################################################################################################################################################################################
## ENV & Key Variables & Directories set up
today=`date '+%Y-%m-%d'`
if [ $# -ne 1 ]; then
	echo "ERROR: Required Parameters are not recieved from UC4."
	echo "INFO: Usage: $0 <ENV> "
	exit 1
else
	log_file="/tmp/SnapMirror_ONTAP2FSxN_"$today"_"$$
	exec > $logfile 2>&1
	echo "STEP#1 START $(date +%x_%r)"
	snapmirror create -source-path svm_source:vol_source -destination-path svm_dest:vol_dest -type DP
	if [ $? -eq 0 ]; then
		echo " Sucuessfully Created SnapMirror Relationship STEP#1 END  $(date +%x_%r)"
		echo "STEP#2 START $(date +%x_%r)"
		sleep 10s
		snapmirror initialize -destination-path svm_dest:vol_dest
  		if [ $? -eq 0 ]; then
    		echo " Sucuessfully Initialized SnapMirror Relationship STEP#2 END  $(date +%x_%r)"
    		echo "STEP#3 START $(date +%x_%r)"
			sleep 10s
    		snapmirror update -destination-path svm_dest:vol_dest
    		if [ $? -eq 0 ]; then
      			echo " Sucuessfully Updated SnapMirror Relationship STEP#3 END  $(date +%x_%r)"
      			echo "STEP#4 START $(date +%x_%r)"
				sleep 10s
      			snapmirror show -destination-path svm_dest:vol_dest
      			if [ $? -eq 0 ]; then
      				echo " Sucuessfully Check SnapMirror Status STEP#4 END  $(date +%x_%r)"
      				echo "STEP#5 START $(date +%x_%r)"
					sleep 10s
      				snapmirror modify -destination-path svm_aws:vol_aws -schedule hourly
      				if [ $? -eq 0 ]; then
      					echo " Sucuessfully Schedule SnapMirror Updates STEP#5 END  $(date +%x_%r)"
      				else 
      					echo " STEP#5 FAIL - Unable to Schedule SnapMirror Updates, Please verify detailed log..! $(date +%x_%r)"
      				fi
      			else
      				echo " STEP#4 FAIL - Unable to Check SnapMirror Status, Please verify detailed log..! $(date +%x_%r)"
      			fi
    		else 
      			echo " STEP#3 FAIL - Unable to Update SnapMirror Relationship, Please verify detailed log..! $(date +%x_%r)"
    		fi
  		else
    		echo " STEP#2 FAIL - Unable to initialize SnapMirror Relationship, Please verify detailed log..! $(date +%x_%r)"
  		fi
	else
  	echo " STEP#1 FAIL - Unable to Create SnapMirror Relationship, Please verify detailed log..! $(date +%x_%r)"
	fi
	
fi
