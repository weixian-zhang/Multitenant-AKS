# SwiftCloud Managed Kubernetes  

This is a project to demostrate the use of a single shared Azure Kubernetes cluster for hosting multiple isolated or related systems managed by different dev teams across the origanization.  
Effectively making Azure Kubernetes a shared "virtual container orchestrated datacenter".

This demostration sets up Azure Kubernetes based on 3 main requirements:  
* [Azure AD Integration for AuthN](https://docs.microsoft.com/en-us/azure/aks/managed-aad)  
* [Azure RBAC for AuthZ (preview)](https://docs.microsoft.com/en-us/azure/aks/azure-ad-rbac?toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Faks%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Fbread%2Ftoc.json)
* [OPA Gatekeeper v3.0](https://github.com/open-policy-agent/gatekeeper) for implementing constraints centrally on a shared AKS.
