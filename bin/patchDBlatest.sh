#!/bin/bash
if [ "$#" -lt 1 ]; then
        echo $0 dbHomeId [region]
        echo $0 ocid1.dbhome......
        exit
fi
dbHomeId=$1
if [ "$2" == "" ]; then
	export TF_VAR_region=us-ashburn-1
else
	export TF_VAR_region=$2
fi
echo Patching DB Home $dbHomeId in region $TF_VAR_region
patchId=`oci db patch list-db-home --all --region $TF_VAR_region --db-home-id $dbHomeId| jq -r '.data[].id'|head -1`
if [ "$patchId" == "" ]; then
	echo DB Home is up-todated
	exit
fi
echo Patching DB with Patch $patchId
oci db db-home update --db-home-id $dbHomeId --force --db-version --region $TF_VAR_region "{ \"action\": \"PRECHECK\", \"patchId\": \"$patchId\" }"
myStatus="IN_PROGRESS"
while [ "$myStatus" == "IN_PROGRESS" ]; do
	echo Still prechecking at
	date
	sleep 30
	myStatus=`oci db patch-history list-db-home --region $TF_VAR_region  --db-home-id $dbHomeId | jq -r '.data[]."lifecycle-state"'|head -1`
done
echo Exit precheck with $myStatus at
date
if [ "$myStatus" != "SUCCEEDED" ]; then
	echo 'Precheck did not succeed, please check and run patch again'
	exit
fi
echo Waiting for DB home to be in available state, max 9 minutes.
for((i=0;i<9;i++)); do
	if [ `oci db db-home get --db-home-id $dbHomeId --region $TF_VAR_region | jq -r '.data."lifecycle-state"'` == "AVAILABLE" ]; then
		break
	fi
	echo Still waiting for DB home to be available at
	date
	sleep 60
done
echo Applying patch.
oci db db-home update --db-home-id $dbHomeId --force --db-version --region $TF_VAR_region "{ \"action\": \"APPLY\", \"patchId\": \"$patchId\" }"
myStatus="IN_PROGRESS"
while [ "$myStatus" == "IN_PROGRESS" ]; do
	echo Still applying at
	date
	sleep 30
	myStatus=`oci db patch-history list-db-home --region $TF_VAR_region  --db-home-id $dbHomeId | jq -r '.data[]."lifecycle-state"'|head -1`
done
echo Exit applying with $myStatus at
date
if [ "$myStatus" != "SUCCEEDED" ]; then
	echo 'Patch did not succeed, please check and run patch again'
fi
