package kubernetes.admission                                                

deny[msg] {                                                                
  input.request.kind.kind == "Service"
  elbName :=  input.request.metadata.name                                  
  elb := input.request.object.spec.type              
  elb == "LoadBalancer"                                  
  msg := sprintf("External Load Balancer '%v' is not allowed. Contact SwiftKube admin", elbName)       
}