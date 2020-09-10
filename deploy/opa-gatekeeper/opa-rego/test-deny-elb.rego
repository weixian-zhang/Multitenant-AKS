package authz

test_deny_elb {                                      
  deny_elb := {                                      
    "request": {
      "kind": {"kind": "Service"},
      "object": {
        "metadata": {
            "name": "public-svc"
        },
        "spec": {
          "type":"LoadBalancer"
        }
      }
    }
  }
  expected := "For security reasons, external load balancer is not allowed by default, contact SwiftKube admin."

}