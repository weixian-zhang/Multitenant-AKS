package swiftcloud.k8s.constraints

violation[{"msg": msg}] {
    input.review.kind.kind = "Service"
    input.review.object.spec.type = "LoadBalancer"
    msg := "For security reasons, external load balancer is not allowed by default, contact SwiftKube admin."
}