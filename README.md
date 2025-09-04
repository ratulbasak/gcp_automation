# gcp_automation

## Project Structure
```bash
.
├── apps
│  └── backend
│     ├── app
│     │  ├── app.py
│     │  ├── static
│     │  │  ├── app.css
│     │  │  └── app.js
│     │  └── templates
│     │     └── index.html
│     ├── Dockerfile
│     └── requirements.txt
├── README.md
└── terraform
   └── cloud-run
      ├── main.tf
      ├── outputs.tf
      ├── providers.tf
      └── variables.tf
```

## Build
```bash
cd apps/backend
docker build -t fastapi .
docker run --rm -p 8000:8000 fastapi
```

## Terraform

Cloud Run terraform apply

```bash
cd terraform/cloud-run
terraform init
terraform plan -var="project_id=<YOUR PROJECT ID>" -var="region=<REGION>"
terraform apply -var="project_id=<YOUR PROJECT ID>" -var="region=<REGION>"
```

### Cleanup 

```bash
terraform destroy -var="project_id=<YOUR PROJECT ID>" -var="region=<REGION>"
```
