# DevOps CI/CD Pipeline

<div align="center">

![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-CI%2FCD-2088FF?style=flat-square&logo=githubactions&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Multi--stage-2496ED?style=flat-square&logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-Reverse%20Proxy-009639?style=flat-square&logo=nginx&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?style=flat-square&logo=terraform&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Ubuntu%2022.04-FCC624?style=flat-square&logo=linux&logoColor=black)

**A complete, production-grade CI/CD pipeline** demonstrating the full DevOps lifecycle from code commit to live deployment.

</div>

---

## 🎯 What This Demonstrates

This repository is a **working DevOps pipeline** — not just configuration files. It shows how a real engineering team deploys software:

1. **Developer pushes code** → GitHub Actions triggers
2. **Automated tests run** → Code must pass to continue
3. **Docker image is built** → Multi-stage, optimized
4. **Image is pushed** → To container registry
5. **Deployment runs** → Zero-downtime to staging/production
6. **Monitoring confirms** → Nginx serves traffic, app is healthy

## 🏗️ Pipeline Architecture

```
Developer Push
      │
      ▼
┌─────────────────────────────────────────────────┐
│              GitHub Actions                      │
│                                                  │
│  ┌──────────┐  ┌──────────┐  ┌───────────────┐  │
│  │   Test   │→ │  Build   │→ │    Deploy     │  │
│  │ (pytest) │  │ (Docker) │  │ (SSH to VPS)  │  │
│  └──────────┘  └──────────┘  └───────────────┘  │
└─────────────────────────────────────────────────┘
                                      │
                                      ▼
                         ┌────────────────────────┐
                         │   DigitalOcean Droplet  │
                         │                        │
                         │  ┌──────────────────┐  │
                         │  │  Nginx (Port 80) │  │
                         │  │  SSL via Certbot │  │
                         │  └────────┬─────────┘  │
                         │           │             │
                         │  ┌────────▼─────────┐  │
                         │  │  Docker Container │  │
                         │  │  (App Port 8000)  │  │
                         │  └──────────────────┘  │
                         └────────────────────────┘
```

## ✅ Features

| Feature | Details |
|---|---|
| 🧪 Automated Testing | pytest runs on every PR, blocks merge if failing |
| 🐳 Multi-stage Docker | Separate build/dev/prod stages for optimized images |
| 🚀 Zero-Downtime Deploy | `docker compose up -d --no-deps` rolling replacement |
| 🔒 SSL/TLS | Let's Encrypt certificates via Certbot + Nginx |
| 🌐 Reverse Proxy | Nginx handles SSL termination and load balancing |
| 🏗️ Infrastructure as Code | Terraform provisions the DigitalOcean droplet |
| 🔐 Secrets Management | GitHub Secrets — no credentials in code |
| 📊 Health Checks | Container health checks + Nginx upstream monitoring |

## 📁 Repository Structure

```
devops-ci-cd-pipeline/
├── .github/
│   └── workflows/
│       ├── ci.yml           # Test & lint on every push/PR
│       └── deploy.yml       # Deploy to server on merge to main
├── app/
│   ├── main.py              # Sample Python web app
│   ├── Dockerfile           # Multi-stage Dockerfile
│   └── requirements.txt
├── nginx/
│   ├── nginx.conf           # Main Nginx configuration
│   └── default.conf         # Server block with SSL & proxy config
├── terraform/
│   ├── main.tf              # DigitalOcean droplet + firewall
│   ├── variables.tf         # Configurable variables
│   └── outputs.tf           # Server IP output
├── scripts/
│   ├── deploy.sh            # Zero-downtime deployment script
│   ├── setup-server.sh      # Initial server bootstrap script
│   └── health-check.sh      # Post-deploy verification
├── docker-compose.yml       # Local development environment
├── docker-compose.prod.yml  # Production compose override
└── README.md
```

## 🚀 How to Use This

### 1. Provision Infrastructure (Terraform)

```bash
cd terraform/
cp terraform.tfvars.example terraform.tfvars
# Add your DigitalOcean token and SSH key ID
terraform init
terraform plan
terraform apply
```

### 2. Bootstrap the Server

```bash
# Run once after provisioning
ssh root@YOUR_SERVER_IP "bash -s" < scripts/setup-server.sh
```

### 3. Configure GitHub Secrets

| Secret | Description |
|---|---|
| `SSH_PRIVATE_KEY` | Private key to SSH into your server |
| `SERVER_HOST` | Your server's IP address |
| `DOCKERHUB_USERNAME` | Docker Hub username |
| `DOCKERHUB_TOKEN` | Docker Hub access token |

### 4. Push Code → Pipeline Runs Automatically

```bash
git push origin main
# Watch GitHub Actions tab — pipeline deploys automatically
```

## 🔧 Nginx Configuration

```nginx
server {
    listen 443 ssl http2;
    server_name yourdomain.com;
    
    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;
    
    location / {
        proxy_pass http://app:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## 🛠️ Built By

**Arnaud Ineza Manzi** — DevOps & Backend Engineer  
📧 ainezamanzi@gmail.com | 🔗 [LinkedIn](https://linkedin.com/in/arnaud-ineza-manzi-471221272)
