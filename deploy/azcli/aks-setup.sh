az aks create --resource-group rg-swiftcloud-kubernetes --name aks-swiftoffice \
--vnet-subnet-id "/subscriptions/ee611083-4581-4ba1-8116-a502d4539206/resourceGroups/rg-swiftcloud-kubernetes/providers/Microsoft.Network/virtualNetworks/vnet-k8s/subnets/subnet-k8s" \
--network-plugin azure \
--network-policy calico \
--enable-aad --enable-azure-rbac \
--aad-admin-group-object-ids fb24271c-88c9-49b4-aa11-bac3b16433d7 \#AAD Group object id
--aad-tenant-id 72f988bf-86f1-41af-91ab-2d7cd011db47 \#AAD tenant id
--node-count 1 --enable-addons monitoring --generate-ssh-keys

az aks create --resource-group rg-swiftcloud-kubernetes --name "aks-swiftoffice" --vnet-subnet-id /subscriptions/ee611083-4581-4ba1-8116-a502d4539206/resourceGroups/rg-swiftcloud-kubernetes/providers/Microsoft.Network/virtualNetworks/vnet-k8s/subnets/subnet-k8s --network-plugin azure --network-policy calico --enable-aad --enable-azure-rbac --aad-admin-group-object-ids fb24271c-88c9-49b4-aa11-bac3b16433d7 --aad-tenant-id 72f988bf-86f1-41af-91ab-2d7cd011db47 --node-count 1 --enable-addons monitoring --generate-ssh-keys