# DevSecops platform project:

## Phase -1 Infrastructure (Terraform + GCP)

This project is a part of "Production level DevSecOps Platform" where I built a complete CI/CD+GitOps+Kubernetes ecosystem

## In Phase-1 - I focussed on :
*Infrastructure provisioning using Terraform
*Deploying VM on Google cloud
*Preparing the base environment for automation ( Ansible, Docker, Kubernetes in later phases)

## ARCHITECTURE: PHASE-1
User -> Terrafrom -> GCP -> Vm (Compute Engine)

## 🧰 Tech Stack

| Tool        | Purpose |
|------------|--------|
| Terraform  | Infrastructure as Code (IaC) |
| GCP        | Cloud provider |
| Compute Engine | Virtual Machine hosting |
| GitHub     | Version control |

---

## 📁 Project Structure
terraform/
├── main.tf # Defines VM infrastructure
├── variables.tf # Input variables (project_id, region)
├── outputs.tf # Outputs like VM public IP


---

## ⚙️ Terraform Configuration Explained

### 🔹 main.tf

- Creates a **GCP Virtual Machine**
- Uses **e2-micro (free tier eligible)**
- Installs **Debian OS**
- Assigns **public IP for SSH access**

### hcl
resource "google_compute_instance" "vm" {
    boot_disk {
  initialize_params {
    image = "debian-cloud/debian-11"
  }
}
- Defines OS image for the VM
- Debian is lightweight and widely used in servers

### network_interface
network_interface {
  network = "default"
  access_config {}
}

- Enables public internet access
- Required to SSH into the VM

🔹 metadata (SSH Key)
metadata = {
  ssh-keys = "viswa:${file("teja_pub.pub")}"
}

- Injects SSH public key into VM
- Allows secure login without password

🔐 Security Considerations
SSH key-based authentication (no passwords)
Minimal open ports
Lightweight VM to reduce attack surface

------------------

## How to Run
1. Initialize Terraform
terraform init
2. Plan Infrastructure
terraform plan

- Shows what resources will be created

3. Apply Configuration
terraform apply

- Creates the VM on GCP

4. Connect to VM
gcloud compute ssh devsecops-vm --zone us-central1-a
📤 Outputs
output "vm_ip" {
  value = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}

- Displays public IP of VM after deployment

- Cost Optimization
Uses e2-micro (free tier eligible)
Uses pd-standard disk (cheap storage)
Avoids managed Kubernetes (cost-heavy)

## Screenshots

![Terraform](https://github.com/Viswa-Tej/GKE-based-GitOps-DevSecOps-Microservices-Platform/blob/31e5a269687722833f00e8bcdfe081d3c222fe14/Screenshots/Terraform-Apply-complete.png)

![GCP](https://github.com/Viswa-Tej/GKE-based-GitOps-DevSecOps-Microservices-Platform/blob/31e5a269687722833f00e8bcdfe081d3c222fe14/Screenshots/GCP-VM-running.png)

![SSH](https://github.com/Viswa-Tej/GKE-based-GitOps-DevSecOps-Microservices-Platform/blob/31e5a269687722833f00e8bcdfe081d3c222fe14/Screenshots/ssh-terminal-VM.png)

![Output](https://github.com/Viswa-Tej/GKE-based-GitOps-DevSecOps-Microservices-Platform/blob/31e5a269687722833f00e8bcdfe081d3c222fe14/Screenshots/Terraform-Apply-complete.png)

## What This Phase Achieves

✔ Infrastructure as Code
✔ Cloud provisioning automation
✔ Secure VM access
✔ Foundation for DevOps pipeline

## Phase -2 Configuration Management (Ansible + Docker + Kubernetes)
### In Phase-2 - I focussed on :

*Automating server setup using Ansible
*Installing Docker for containerization
*Installing Kubernetes (k3s) for orchestration
*Preparing environment for microservices deployment

## ARCHITECTURE: PHASE-2

User → Ansible → VM → Docker + Kubernetes (k3s)

### Tech Stack
Tool	Purpose
Ansible	Configuration Management
Docker	Container Runtime
k3s	Lightweight Kubernetes
Linux VM	Execution Environment

### Project Structure
ansible/
├── inventory.ini      # Defines target host (localhost)
├── setup.yml          # Playbook for automation
⚙️ Ansible Configuration Explained
🔹 inventory.ini
[local]
localhost ansible_connection=local
Defines target machine as local VM
Uses local connection (no SSH required)
🔹 setup.yml
1. Update system packages
- name: Update packages
  apt:
    update_cache: yes

-  Ensures latest package list

2. Install Docker
- name: Install Docker
  apt:
    name: docker.io
    state: present

- Installs Docker runtime

3. Start Docker
- name: Start Docker
  service:
    name: docker
    state: started
    enabled: true

- Ensures Docker runs automatically

4. Install Kubernetes (k3s)
- name: Install k3s
  shell: curl -sfL https://get.k3s.io | sh -

- Installs lightweight Kubernetes cluster

🔐 Security Considerations
Minimal packages installed
No unnecessary ports exposed
Localhost execution (no remote SSH risk)
🚀 How to Run
ansible-playbook -i inventory.ini setup.yml
📤 Outputs
Docker installed and running
Kubernetes cluster initialized
Node ready for deployments
📸 Screenshots

(Add your images here)

### What This Phase Achieves

✔ Automated server configuration
✔ Docker runtime setup
✔ Kubernetes cluster provisioning
✔ Ready for application deployment

## Phase -3 Microservices Deployment (Docker + Kubernetes)
### In Phase-3 - I focussed on :

*Building a containerized application
*Deploying application into Kubernetes
*Exposing application to external users
*Handling real-world networking issues (firewall)

### ARCHITECTURE: PHASE-3

User → Browser → NodePort → Kubernetes Service → Pod → Container

### Tech Stack
Tool	Purpose
Node.js	Microservice application
Docker	Containerization
Kubernetes	Deployment & orchestration
k3s	Lightweight cluster
GCP	Hosting environment

### Project Structure
app/
├── app.js              # Node.js application
├── Dockerfile          # Container image definition
├── deployment.yaml     # Kubernetes Deployment
├── service.yaml        # Kubernetes Service
⚙️ Application Explained
🔹 app.js
const http = require("http");

const server = http.createServer((req, res) => {
  res.end("DevSecOps Project Running 🚀");
});

server.listen(3000);

- Simple Node.js server

🔹 Dockerfile
FROM node:18-alpine
WORKDIR /app
COPY app.js .
CMD ["node", "app.js"]

- Builds lightweight container image

🐳 Docker Steps
docker build -t devsecops-app .
docker run -d -p 3000:3000 devsecops-app

- Validates application locally

☸️ Kubernetes Deployment
🔹 deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: devsecops-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: devsecops
  template:
    metadata:
      labels:
        app: devsecops
    spec:
      containers:
      - name: app
        image: devsecops-app:latest
        imagePullPolicy: Never
        ports:
        - containerPort: 3000

👉 Runs container inside cluster

🌐 Kubernetes Service
🔹 service.yaml
apiVersion: v1
kind: Service
metadata:
  name: devsecops-service
spec:
  type: NodePort
  selector:
    app: devsecops
  ports:
    - port: 80
      targetPort: 3000
      nodePort: 30007

👉 Exposes app externally

🔥 Important Step (k3s Image Import)
docker save devsecops-app | sudo k3s ctr images import -

👉 Makes local Docker image available to Kubernetes

🌍 Access Application
http://<VM-IP>:30007
🔐 Cloud Firewall Fix
Open port 30007 in GCP firewall
Required for external access
📸 Screenshots

(Add your images here)

📊 What This Phase Achieves

✔ Containerized application
✔ Kubernetes deployment
✔ Service exposure
✔ Real-world debugging (YAML errors, firewall issues)

🧠 Key Learnings (Phase 2 & 3)
Infrastructure automation using Ansible
Kubernetes cluster setup and troubleshooting
Docker to Kubernetes workflow
Debugging real issues:
Resource limits (OOM)
YAML errors
Firewall restrictions
🔜 Next Phases

Phase 4: CI/CD with GitHub Actions
Phase 5: Monitoring (Prometheus + Grafana)
Phase 6: GitOps (ArgoCD + Helm)

Phase 4: CI/CD with GitHub Actions
Phase 5: Monitoring (Prometheus + Grafana)
Phase 6: GitOps (ArgoCD + Helm)
👨‍💻 Author

Viswa
DevOps Engineer | Cloud | Kubernetes | Automation