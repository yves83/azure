#!/bin/bash

subkey=$1
rg=$2
ws=$3
tab=$4

az monitor log-analytics workspace table show --subscription $subkey --resource-group $rg --workspace-name $ws --name $tab --output json > cef.json
jq -r '.schema.standardColumns' cef.json > colstmp.json
jq 'del(.[] | select(.name == "TenantId"))' colstmp.json > cols.json

cat <<EOF | sed "s/###TABLE###/$tab/g" > create_table.ps1
\$tableParams = @'
{
    "properties": {
        "schema": {
            "name": "###TABLE###_CL",
            "columns": 
EOF

cat cols.json >> create_table.ps1

cat <<EOF >> create_table.ps1
        }
    }
}
'@
EOF

echo 'Invoke-AzRestMethod -Path "/subscriptions/###SUBKEY###/resourcegroups/###RG###/providers/microsoft.operationalinsights/workspaces/###WKSPACE###/tables/###TABLE###_CL?api-version=2021-12-01-preview" -Method PUT -payload $tableParams' \
| sed s/###SUBKEY###/$subkey/g \
| sed s/###RG###/$rg/g \
| sed s/###WKSPACE###/$ws/g \
| sed s/###TABLE###/$tab/g >> create_table.ps1

rm cols.json colstmp.json cef.json
