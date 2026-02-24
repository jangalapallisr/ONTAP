#!/bin/bash
set -x
################################################################################################################################################################################################
#Script Name:   ONTAP2FSxN_SnapMirror.sh
#Author:        Subbu Jangalapalli
#Date:          02/24/2026
###Description:   This script is for to:
###1. Create SnapMirror Relationship
###2. Initialize SnapMirror Relationship
###3. Update SnapMirror Relationship (Incremental Updates)
###4. Check SnapMirror Status
###5. Schedule SnapMirror Updates
#
#Usage:     	<Script Name > <arg1> <arg2> <arg3> <arg4> <arg5>
#					//arg1 is for all actions [all] or any specific actions[create|init|update|check|schedule] on ad-hoc basis;
#					//arg2 svm_source (On-premises SVM)
#					//arg3 vol_source (On-premises volume)
#					//arg4 svm_dest (AWS FSxN SVM)
#					//arg5 vol_dest (AWS FSxN volume)
#Examle:    	./ONTAP2FSxN_SnapMirror.sh  all svm_ontap vol_ontap svc_fsxn vol_fsxn
#
# Change History:
#----------------------------------------------------------------------------------------------------------------------------
#Date            	Name/ID              Change Description with reference Ticket number
#02/24/2026        	Subbuj               Initial Creation of the script
#
##################################################################################################################################################################################################
## ENV Variables & Directories set up
today=`date '+%Y-%m-%d'`
log_file="/tmp/ONTAP2FSxN_SnapMirror_"$today"_"$$
exec > $log_file 2>&1

create()
{
	echo "Starting service...$(date +%x_%r) To Create SnapMirror Relationship"
        #snapmirror create -source-path svm_source:vol_source -destination-path svm_dest:vol_dest -type DP
        snapmirror create -source-path $1:$2 -destination-path $3:$4 -type DP
	if [ $? -eq 0 ]; then
		echo "END: Sucuessfully Created SnapMirror Relationship $(date +%x_%r)"
		exit 0
	else
		echo "ERROR: Unable to Create SnapMirror Relationship, Please verify detailed log..! $(date +%x_%r)"
		exit 1
	fi
}

initalize()
{
        echo "Starting service...$(date +%x_%r) To Initialize SnapMirror Relationship"
        #snapmirror initialize -destination-path svm_dest:vol_dest
        snapmirror initialize -destination-path $1:$2
        if [ $? -eq 0 ]; then
                echo "END: Sucuessfully Initialized SnapMirror Relationship $(date +%x_%r)"
                exit 0
        else
                echo "ERROR: Unable to Initialize SnapMirror Relationship, Please verify detailed log..! $(date +%x_%r)"
                exit 1
        fi
}

update()
{
        echo "Starting service...$(date +%x_%r) To Update SnapMirror Relationship"
        #snapmirror update -destination-path svm_dest:vol_dest
        snapmirror update -destination-path $1:$2
        if [ $? -eq 0 ]; then
                echo "END: Sucuessfully Updated SnapMirror Relationship $(date +%x_%r)"
                exit 0
        else
                echo "ERROR: Unable to Update SnapMirror Relationship, Please verify detailed log..! $(date +%x_%r)"
                exit 1
        fi
}

check()
{
        echo "Starting service...$(date +%x_%r) To Check SnapMirror Status"
        #snapmirror show -destination-path svm_dest:vol_dest
        snapmirror show -destination-path $1:$2
        if [ $? -eq 0 ]; then
                echo "END: Sucuessfully able to Check SnapMirror Status $(date +%x_%r)"
                exit 0
        else
                echo "ERROR: Unable to Check SnapMirror Status, Please verify detailed log..! $(date +%x_%r)"
                exit 1
        fi
}

schedule()
{
        echo "Starting service...$(date +%x_%r) To Schedule SnapMirror Updates"
        #snapmirror modify -destination-path svm_dest:vol_dest -schedule hourly
        snapmirror modify -destination-path $1:$2 -schedule hourly
        if [ $? -eq 0 ]; then
                echo "END: Sucuessfully Scheduled SnapMirror Updates $(date +%x_%r)"
                exit 0
        else
                echo "ERROR: Unable to Schedule SnapMirror Updates, Please verify detailed log..! $(date +%x_%r)"
                exit 1
        fi
}

if [ $# -ne 5 ]; then
	echo "ERROR: Required Parameters are not recieved, please verify the usage."
	echo "INFO: Usage: $0 {all|create|init|update|check|schedule} {svm_source} {vol_source} {svm_dest} {vol_dest}"
	exit 1
else
case "$1" in
    all)
        echo "Starting all services...create|init|update|check|schedule"
	      create $2 $3 $4 $5
	      initalize $4 $5
	      update $4 $5
	      check $4 $5
	      schedule $4 $5
        ;;
    create)
        echo "Starting service...create"
	      create $2 $3 $4 $5
        ;;
    initalize)
        echo "Starting service...initalize"
	      initalize $4 $5
        ;;
    update)
        echo "Starting service...update"
	      update $4 $5
        ;;
    check)
        echo "Starting service...Status check"
	      check $4 $5
        ;;
    schedule)
        echo "Starting service...schedule Update"
        schedule $4 $5
        ;;
    *)
        echo $"Usage: $0 {all|create|init|update|check|schedule} {svm_source} {vol_source} {svm_dest} {vol_dest}"
        exit 1
        ;;
esac
fi
