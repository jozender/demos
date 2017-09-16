#!/bin/bash

# assumes you are logged into az cli and have ssh keys

set -evx

rgname="ignite$RANDOM"
location="centralus"
vmsku="Standard_F1"
vmname="counter"
vmssname="pushers"
#pubkeypath="/home/negat/.ssh/id_rsa.pub"
uriBase="https://raw.githubusercontent.com/gatneil/scripts/master/"

az group create --name $rgname --location $location

az vmss create --resource-group $rgname --name $vmssname --image UbuntuLTS --instance-count 10

az vmss extension set --publisher "Microsoft.Azure.Extensions" --name "CustomScript" --resource-group $rgname --vmss-name $vmssname --settings "{\"fileUris\": [\"https://raw.githubusercontent.com/gatneil/demos/ignite2017/ignite2017/install_ml_server.sh\"], \"commandToExecute\": \"bash install_ml_server.sh ${pip}\"}"

exit 0

az vm create --resource-group $rgname --name $vmname --image UbuntuLTS --admin-username negat --nsg "" --size $vmsku

az vm extension set --publisher "Microsoft.Azure.Extensions" --name "CustomScript" --resource-group $rgname --vm-name $vmname --settings "{\"fileUris\": [\"${uriBase}install_count_requests.sh\"], \"commandToExecute\": \"bash install_count_requests.sh ${uriBase}\"}"

pip=`az network public-ip show --resource-group $rgname --name "$vmname"PublicIP | grep  \"ipAddress\" | cut -d "\"" -f 4`:5000

echo $pip


