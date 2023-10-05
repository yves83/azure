#!/bin/bash

if [[ $# -ne 4 ]]; 
then 
    echo "Argument mismatch"
    echo -e "Usage: \n$0 {SubscriptionID} {ResourceGroup} {WorkspaceName} {TotalRetentionTime}"
    exit 1
fi

subkey=$1
rg=$2
ws=$3
trt=$4

#az monitor log-analytics workspace table list --subscription $subkey --resource-group $rg --workspace-name $ws --output json > tab_list.json
jq -r '.[] | .name' tab_list.json > tab_name
for n in `cat tab_name`;
do
   echo "az monitor log-analytics workspace table update --subscription $subkey --resource-group $rg --workspace-name $ws --name $n --total-retention-time $trt --no-wait"
   az monitor log-analytics workspace table update --subscription $subkey --resource-group $rg --workspace-name $ws --name $n --total-retention-time $trt --no-wait
done

rm -f tab_list.json
rm -f tab_name
