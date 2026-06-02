# DevOps End-to-End Assessment Project

## Project Overview

This project demonstrates an end-to-end DevOps workflow by deploying a containerized Flask application behind an Nginx reverse proxy on AWS EC2. The project includes Docker containerization, reverse proxy configuration, AWS deployment, monitoring, automation, and documentation.

---

## Live Deployment

**Public URL**

```text
http://13.233.114.104
```

**Health Endpoint**

```text
http://13.233.114.104/health
```

---

## Application Endpoints

### Home Endpoint

```http
GET /
```

Response:

```json
{
  "message": "Hello from DevOps Assessment"
}
```

### Health Endpoint

```http
GET /health
```

Response:

```json
{
  "status": "ok"
}
```

---

## Architecture Overview

```text
                    Internet
                        |
                        v
                Nginx Reverse Proxy
                    Port 80
                        |
                        v
              Flask Application
                    Port 5000
                        |
                        v
                 Docker Network
                        |
                        v
                   AWS EC2
```

### Port Mapping

| Component         | Port |
| ----------------- | ---- |
| Nginx             | 80   |
| Flask Application | 5000 |

Only Nginx is exposed publicly.

The Flask application is accessible only through the internal Docker network.

---

## Technologies Used

* Python Flask
* Docker
* Docker Compose
* Nginx
* AWS EC2 (Ubuntu)
* Linux Shell Scripting
* Git & GitHub
* Cron Jobs

---

## Repository

GitHub Repository:

```text
https://github.com/Laxmi7676/Devops-Assessement-Project
```

---

## Project Structure

```text
Devops-Assessement-Project/
│
├── app/
│   ├── app.py
│   └── requirements.txt
│
├── nginx/
│   └── nginx.conf
│
├── Dockerfile
├── docker-compose.yml
├── deploy.sh
├── health-check.sh
└── README.md
```

---

## Docker Containerization

### Build Docker Image

```bash
docker build -t flask-app .
```

### Run Container

```bash
docker run -p 5000:5000 flask-app
```

### Docker Best Practices Followed

* Official slim Python base image
* Non-root application user
* Only required files copied
* Gunicorn used as production WSGI server

---

## Docker Compose

Start complete stack:

```bash
docker compose up -d --build
```

Stop stack:

```bash
docker compose down
```

This starts:

* Flask Application Container
* Nginx Reverse Proxy Container

---

## Reverse Proxy Configuration

Nginx listens on:

```text
Port 80
```

and forwards requests internally to:

```text
Flask Application Port 5000
```

Example:

```nginx
location / {
    proxy_pass http://app:5000;
}
```

Traffic Flow:

```text
Client
   |
Port 80
   |
Nginx
   |
Port 5000
   |
Flask Application
```

---

## Local Deployment

Clone repository:

```bash
git clone https://github.com/Laxmi7676/Devops-Assessement-Project.git

cd Devops-Assessement-Project
```

Build and start:

```bash
docker compose up -d --build
```

Verify:

```bash
curl localhost
```

```bash
curl localhost/health
```

---

## AWS EC2 Deployment

### EC2 Configuration

* Instance Type: t3.micro
* Operating System: Ubuntu Server
* Region: ap-south-1

### Security Group Rules

| Type | Port | Source   |
| ---- | ---- | -------- |
| SSH  | 22   | My IP    |
| HTTP | 80   | Anywhere |

No other application ports are publicly exposed.

### Install Docker

```bash
sudo apt update

sudo apt install docker.io docker-compose-v2 git -y
```

### Enable Docker

```bash
sudo systemctl enable docker

sudo systemctl start docker
```

### Add User To Docker Group

```bash
sudo usermod -aG docker ubuntu

newgrp docker
```

### Clone Repository

```bash
git clone https://github.com/Laxmi7676/Devops-Assessement-Project.git

cd Devops-Assessement-Project
```

### Deploy Application

```bash
chmod +x deploy.sh

./deploy.sh
```

or

```bash
docker compose up -d --build
```

---

## Deployment Automation

Deployment is automated using:

```text
deploy.sh
```

Run:

```bash
./deploy.sh
```

Functions performed:

* Updates package information
* Stops existing containers
* Rebuilds Docker images
* Starts application stack
* Stops execution if an error occurs

---

## Monitoring

Monitoring is implemented using:

```text
health-check.sh
```

and

```text
Cron Jobs
```

### Health Check Script

Checks:

```text
http://localhost/health
```

If response code is:

```text
200
```

status is recorded as:

```text
UP
```

Otherwise:

```text
DOWN
```

### Cron Configuration

```bash
*/5 * * * * /home/ubuntu/Devops-Assessement-Project/health-check.sh
```

This executes the monitoring script every 5 minutes.

### Log File

```text
/home/ubuntu/health.log
```

Example:

```text
Tue Jun 2 19:02:18 UTC 2026 - UP
Tue Jun 2 19:04:22 UTC 2026 - DOWN
Tue Jun 2 19:05:10 UTC 2026 - UP
```

---

## Downtime Demonstration

### Stop Application

```bash
docker stop flask-app
```

Monitoring log records:

```text
DOWN
```

### Restart Application

```bash
docker start flask-app
```

Monitoring log records:

```text
UP
```

Demonstrated sequence:

```text
UP → DOWN → UP
```

This confirms successful outage detection and recovery monitoring.

---

## Acceptance Criteria Validation

### Docker

* Dockerfile builds successfully
* Application container runs successfully

### Reverse Proxy

* Nginx exposed publicly
* Flask port not exposed

### AWS

* EC2 instance deployed
* Application publicly reachable

### Monitoring

* Health checks implemented
* Downtime detected
* Recovery detected

### Automation

* Deployment script implemented
* Monitoring script implemented

---

## Challenges Faced

### SSH Connection Issues

Problem:

```text
Connection timed out
```

Resolution:

* Updated Security Group rules
* Verified SSH access configuration

### PEM Key Permission Issue

Problem:

```text
UNPROTECTED PRIVATE KEY FILE
```

Resolution:

* Copied PEM file into Linux home directory
* Applied secure permissions using chmod 400

### Cron Log Permissions

Problem:

Writing to:

```text
/var/log
```

required elevated permissions.

Resolution:

Changed log location to:

```text
/home/ubuntu/health.log
```

---

## Improvements With More Time

* HTTPS using Let's Encrypt
* GitHub Actions CI/CD Pipeline
* Prometheus Monitoring
* Grafana Dashboard
* AWS CloudWatch Alarms
* Custom Domain Name
* Automated Rollback Strategy
* Multi-Environment Deployment (Dev/QA/Prod)

---

## Conclusion

This project demonstrates the complete DevOps lifecycle including application containerization, reverse proxy configuration, AWS deployment, monitoring, automation, troubleshooting, and documentation. The application is publicly accessible through AWS EC2 and includes automated uptime monitoring with downtime detection and recovery validation.

