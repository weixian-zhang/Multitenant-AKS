#setup AKS
az aks create --resource-group resource_group_name --name aks_cluster_name \
--enable-aad --enable-azure-rbac \
--aad-admin-group-object-ids xxxx271c-88xx-49xx-aaxx-baxxxxxxxx \
--aad-tenant-id xxxxx8bf-8xxx-4xxx-9xxx-2d7xxxxxxxxx \
--node-count 1 --enable-addons monitoring --generate-ssh-keys

#get AKS ID
AKS_ID=$(az aks show -g MyResourceGroup -n MyManagedCluster --query id -o tsv)

#add user group as cluster admins
az role assignment create --role "Azure Kubernetes Service RBAC Cluster Admin" --assignee <AAD/Group/Properties/Group-Object-ID> --scope $AKS_ID 

#add user groups as non-cluster admin to multiple namespaces
az role assignment create --role "Azure Kubernetes Service RBAC Admin" --assignee <AAD/Group/Properties/GroupObject-ID> --scope $AKS_ID/namespaces/<namespace-name>