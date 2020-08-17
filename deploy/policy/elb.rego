package kubernetes.admission

import data.kubernetes.namespaces

import input.request.object.metadata.annotations as annotations

deny[msg] {
    input.request.kind.kind = "Service"
    input.request.object.spec.type = "LoadBalancer"
    msg = "LoadBalancer Services are not permitted"
}

# deny[msg] {
#   input.request.kind.kind = "Service"
#   input.request.object.spec.type = "LoadBalancer"
#   msg ="External Load Balancer is not allowed. Contact SwiftKube admin"   
# }