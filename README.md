# CloudScale — Final Project (AKS + ACR + Terraform + GitHub Actions)

Cloud Computing & DevOps Engineering
Instructor: M.Sc. Abdelhakim Rashid

Team
- Hussain Saleem — 4891
- Ramadan Swedik — 4761

Live app: http://74.161.70.26
Repository: https://github.com/hussain14saleem1-lgtm/cloud-Fproject

## 1. Project Description
CloudScale needs to deploy a containerized web application to Azure using DevOps
best practices. This project builds a complete CI/CD pipeline that:
- Containerizes a Node.js web app with Docker (custom message + /health endpoint)
- Stores the image in Azure Container Registry (ACR)
- Provisions infrastructure (AKS + ACR) with Terraform
- Deploys the app to Azure Kubernetes Service (AKS)
- Automates build, push, and deploy with GitHub Actions
- Protects production with a manual approval gate

## 2. Technology Stack
| Layer | Technology |
|-------|-----------|
| Containerization | Docker, Azure Container Registry (ACR) |
| Application | Node.js + Express |
| Infrastructure as Code | Terraform (azurerm provider) |
| Orchestration | Azure Kubernetes Service (AKS) |
| CI/CD | GitHub Actions |
| Approval gate | GitHub Environments (required reviewers) |
| Secrets | GitHub Actions Secrets + Azure Service Principal |

## 3. Repository Structure
cloud-Fproject/
├── app.js                  # Node.js web app (custom message + /health)
├── package.json            # App dependencies (Express)
├── Dockerfile              # Builds the app image
├── .dockerignore
├── .gitignore
├── providers.tf            # azurerm provider
├── variables.tf            # Input variables
├── main.tf                 # Resource Group + ACR + AKS + ACR-pull role + tags
├── outputs.tf              # Outputs (ACR login server, AKS name, RG name)
├── k8s/
│   ├── deployment.yaml     # 3 replicas, image from ACR, liveness/readiness probes
│   └── service.yaml        # LoadBalancer service
└── .github/workflows/
    └── ci-cd.yml           # Build/test + push to ACR + deploy to AKS (approval gate)

## 4. Setup Instructions

### Prerequisites
Docker Desktop, Azure CLI (az), Terraform, kubectl, Git, and an Azure for Students subscription (az login).

### Docker
docker build -t hussainacrfinal2026.azurecr.io/cloudscale-final:v1 .
az acr login --name hussainacrfinal2026
docker push hussainacrfinal2026.azurecr.io/cloudscale-final:v1

### Terraform (provision AKS + ACR)
terraform init
terraform plan
terraform apply

### Kubernetes (deploy)
az aks get-credentials --resource-group hussain-final-aks-rg --name hussain-final-aks
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl get service cloudscale-service

## 5. Architecture
Developers (2 laptops)            GitHub Repository
 Hussain & Ramadan   --push/PR-->  cloud-Fproject
                                        |
                  +---------------------+---------------------+
                  | Pull Request                  Push to main |
                  v                                            v
          terraform plan /                      MANUAL APPROVAL GATE
          build & test (CI)                     (production environment)
                                                         | approved
                                                         v
                                              Build image -> push to ACR
                                                         |
                                                         v
                                              Deploy to AKS (kubectl)
                                                         |
   Azure Container Registry  --image pull (no secrets)-> AKS cluster (3 pods)
   hussainacrfinal2026.azurecr.io                        |
                                              LoadBalancer (public IP)
                                                         |
                                                         v
                                                http://74.161.70.26

## 6. GitHub Actions Workflow
The pipeline is defined in .github/workflows/ci-cd.yml and has two jobs:
1. build-and-test — runs on every push and pull request. It builds the Docker
   image and checks the /health endpoint responds.
2. deploy — runs only on push to main, behind the production environment.
   GitHub pauses and waits for a required reviewer to approve (the manual approval
   gate). After approval it logs into Azure with the service principal, pushes the
   image to ACR, and deploys to AKS with kubectl.

Authentication uses the GitHub Secret AZURE_CREDENTIALS (an Azure service
principal). No secrets are stored in the code.

## 7. AKS + ACR Integration
AKS pulls images from ACR with no imagePullSecrets. Terraform grants the AKS
managed identity the AcrPull role on the registry (azurerm_role_assignment).

## 8. Screenshots
1. Docker build successful
2. Image in ACR
3. terraform apply successful
4. AKS nodes ready
5. Application running in browser
6. GitHub Actions workflow successful
7. GitHub Actions approval gate
8. Azure Portal showing AKS + ACR

## 9. Estimated Cost (10 days)
| Resource | Cost |
|----------|------|
| AKS control plane | Free |
| Worker nodes (2 × Standard_B2s_v2) | ~$13–16 |
| ACR Basic | ~$2.50 |
| Total | ~$16–18 (well within the $100 student credit) |

## 10. Cleanup
terraform destroy
Always destroy the resources after grading to avoid charges.

## Notes
The region switzerlandnorth and node size Standard_B2s_v2 were used because the
Azure for Students subscription blocks eastus and Standard_B2s (the handout's
defaults). These are the closest allowed equivalents.