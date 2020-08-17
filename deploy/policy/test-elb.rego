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
  expected := "External Load Balancer 'public-svc' is not allowed. Contact SwiftKube admin"

}