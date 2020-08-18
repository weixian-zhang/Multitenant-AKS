#setup AKS
az aks create --resource-group resource_group_name --name aks_cluster_name \
--enable-aad --enable-azure-rbac \
--aad-admin-group-object-ids xxxxxxxx-88xx-49xx-aaxx-baxxxxxxxx \ #AAD Group object id
--aad-tenant-id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \ #AAD tenant id
--node-count 1 --enable-addons monitoring --generate-ssh-keys

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