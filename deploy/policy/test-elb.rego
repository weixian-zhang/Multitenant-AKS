package kubernetes.test_admission                         # line 1

import data.kubernetes.admission                          # line 2

test_deny_elb {                                       # line 3
  deny_elb := {                                       # line 4
    "request": {
      "kind": {"kind": "Service"},
      "object": {
        "metadata": {
            "name": "public-svc"
        },
      }
    }
  }
  expected := "External Load Balancer 'public-svc' is not allowed. Contact SwiftKube admin"
  admission.deny[expected] with input as deny_elb     # line 5
}