# ONTAP
**High-Level Steps for SnapMirror from ONTAP On-Prem to AWS FSxN**
  1. Prepare the source and destination volumes (on-prem and FSxN).
  2. Create SnapMirror endpoints (SVMs on both sides).
  3. Create SnapMirror policy and schedule (optional, default policies exist).
  4. Initialize SnapMirror relationship.
  5. Monitor and manage SnapMirror relationships.

**1. Create SnapMirror Endpoint on Source (On-Prem ONTAP)**

::> snapmirror create -source-path svm_source:vol_source -destination-path svm_dest:vol_dest -type DP
    svm_source:vol_source is the source volume path on on-prem ONTAP.
    svm_dest:vol_dest is the destination volume path on AWS FSxN.
    -type DP means Data Protection (SnapMirror).

**2. Initialize SnapMirror Relationship**

::> snapmirror initialize -destination-path svm_dest:vol_dest
    This starts the initial baseline transfer.
    
**3. Update SnapMirror Relationship (Incremental Updates)**

::> snapmirror update -destination-path svm_dest:vol_dest
    Run this periodically or schedule it for incremental replication.

**4. Check SnapMirror Status**

::> snapmirror show -destination-path svm_dest:vol_dest

**5. Optional: Schedule SnapMirror Updates**

::> snapmirror modify -destination-path svm_aws:vol_aws -schedule hourly
    You can schedule SnapMirror updates to run automatically, for example every hour:


file_path="/tmp/my_snapmirror.sh"
echo "snapmirror create -source-path svm_source:vol_source -destination-path svm_dest:vol_dest -type DP" >> $file_path
echo "snapmirror initialize -destination-path svm_dest:vol_dest" >> $file_path
echo "snapmirror update -destination-path svm_dest:vol_dest" >> $file_path
echo "snapmirror show -destination-path svm_dest:vol_dest" >> $file_path
echo "snapmirror modify -destination-path svm_aws:vol_aws -schedule hourly" >> $file_path

**Notes**
The destination volume vol_aws must exist and be empty before creating the SnapMirror relationship.
You may need to configure SnapMirror policies if you want to customize retention, transfer rates, or snapshot schedules.
Ensure network connectivity and authentication between the two ONTAP systems.
You can also use snapmirror break and snapmirror resync commands to manage SnapMirror relationships during failover or resync scenarios.

**Additional Notes**
You may need to configure SnapMirror relationships with appropriate SnapMirror policies and schedules.
Ensure that the destination volume exists and is empty or prepared for SnapMirror.
Network and security configurations (firewalls, VPNs, VPC peering) must allow SnapMirror traffic.
SnapMirror can be synchronous or asynchronous; typically, on-prem to cloud is asynchronous.
For SVM DR (disaster recovery), you might use SVM SnapMirror relationships instead of volume-level.

**Here in Example Setup**
  On-premises SVM: svm_onprem
  On-premises volume: vol_onprem
  AWS FSxN SVM: svm_aws
  AWS FSxN volume: vol_aws
