az aks create --resource-group rg-swiftcloud-kubernetes --name aks-swiftcloud-dev \
--enable-aad --enable-azure-rbac \
--aad-admin-group-object-ids fb24271c-88c9-49b4-aa11-bac3b16433d7 \
--aad-tenant-id 72f988bf-86f1-41af-91ab-2d7cd011db47\
--node-count 1 --enable-addons monitoring --generate-ssh-keys