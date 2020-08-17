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

#OPA setup
#https://medium.com/capital-one-tech/policy-enabled-kubernetes-with-open-policy-agent-3b612b3f0203

#create ssl cret as secret for opa->kube-api-server comms
kubectl create secret tls opa-server --cert=server.crt --key=server.key

#OPA cli download, needed for rego test
#https://www.openpolicyagent.org/docs/latest/#running-opa

#deploy repolicy as configmap
kubectl create configmap policy-elb --from-file=./policy/elb.rego -n opa
