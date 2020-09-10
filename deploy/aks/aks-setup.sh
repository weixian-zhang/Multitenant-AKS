#setup AKS
az aks create --resource-group rg-swiftcloud-kubernetes --name aks-swiftoffice \
--vnet-subnet-id "/subscriptions/xxxxxxxxx-4581-4ba1-8116-xxxxxxxxxxxx/resourceGroups/rg-swiftcloud-kubernetes/providers/Microsoft.Network/virtualNetworks/vnet-k8s/subnets/subnet-k8s" \
--network-plugin azure \
--network-policy calico \
--enable-aad --enable-azure-rbac \
--aad-admin-group-object-ids xxxxxxxx-88c9-49b4-aa11-xxxxxxxxxxxxx \
--aad-tenant-id 72f988bf-86f1-41af-91ab-xxxxxxxxxxxx \
--node-count 1 --enable-addons monitoring --generate-ssh-keys \
--enable-addons monitoring
#same as above without linebreak
az aks create --resource-group rg-swiftcloud-kubernetes --name "aks-swiftkube" --vnet-subnet-id /subscriptions/ee611083-4581-4ba1-8116-a502d4539206/resourceGroups/rg-swiftcloud-kubernetes/providers/Microsoft.Network/virtualNetworks/vnet-k8s/subnets/subnet-k8s --network-plugin azure --network-policy calico --enable-aad --enable-azure-rbac --aad-admin-group-object-ids fb24271c-88c9-49b4-aa11-bac3b16433d7 --aad-tenant-id 72f988bf-86f1-41af-91ab-2d7cd011db47 --node-count 1 --enable-addons monitoring --generate-ssh-keys

az aks get-credentials --resource-group rg-swiftcloud-kubernetes --name aks-swiftoffice

#get AKS ID
AKS_ID=$(az aks show -g MyResourceGroup -n MyManagedCluster --query id -o tsv)

#assign group as cluster admins role
az role assignment create --role "Azure Kubernetes Service RBAC Cluster Admin" \
--assignee <AAD/Group/Properties/Group-Object-ID> --scope $AKS_ID 

#assign groups as non-cluster admin to one or more namespaces
az role assignment create --role "Azure Kubernetes Service RBAC Admin" \
--assignee <AAD/Group/Properties/GroupObject-ID> --scope $AKS_ID/namespaces/<namespace-name>

#OPA Gatekeep v3.0 setup
#https://github.com/open-policy-agent/gatekeeper
kubectl create ns swiftcaps-apps