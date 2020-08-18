# SwiftCloud Managed Kubernetes  

This is a project to demostrate the use of a single shared Azure Kubernetes cluster for hosting multiple isolated or related systems managed by different dev teams across the origanization.  
Effectively making Azure Kubernetes a shared "virtual container orchestrated datacenter".

This demostration sets up Azure Kubernetes based on 3 main requirements:  
*Azure AD Integration for AuthN
*Azure RBAC for AuthZ (preview).
*[OPA Gatekeeper v3.0](https://github.com/open-policy-agent/gatekeeper) for implementing constraints centrally on a shared AKS.
