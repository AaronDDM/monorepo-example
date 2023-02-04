# Requirements
1. `brew install terraform`
2. `brew install terragrunt`
3. `brew install kubectl`
4. `brew install gcloud`

# Usage (example)
1. `cd packages/infrastructure/terraform/environment/dev/us-east1/vpc/private`
2. `terragrunt init`
3. `terragrunt plan`
4. `terragrunt apply`

# GCP Pre-requisites
- Enable "Compute Engine API" (https://console.cloud.google.com/apis/library/compute.googleapis.com)
- Enable "Kubernetes Engine API" (https://console.cloud.google.com/apis/library/container.googleapis.com)
