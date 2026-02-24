
log_file="/tmp/my_snapmirror.sh"
echo "snapmirror create -source-path svm_source:vol_source -destination-path svm_dest:vol_dest -type DP" >> $file_path
echo "snapmirror initialize -destination-path svm_dest:vol_dest" >> $file_path
echo "snapmirror update -destination-path svm_dest:vol_dest" >> $file_path
echo "snapmirror show -destination-path svm_dest:vol_dest" >> $file_path
echo "snapmirror modify -destination-path svm_aws:vol_aws -schedule hourly" >> $file_path
