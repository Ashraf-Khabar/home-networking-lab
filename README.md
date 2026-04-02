# Home Networking Lab: K3s, Pi-hole & Monitoring (SRE)

This project is a Kubernetes-based Home Lab for network infrastructure. 
It deploys an ad-blocking DNS server (Pi-hole) and a full observability stack (Prometheus & Grafana) using DevOps/SRE best practices (Infrastructure as Code, Helm).

## Prerequisites

Before running this project, ensure you have:
* A working Kubernetes cluster (K3s or Docker Desktop Kubernetes).
* The `kubectl` command-line tool.
* The `helm` package manager (v3).

---

## Phase 1: Pi-hole Deployment (DNS Sinkhole)

Pi-hole is deployed using standard YAML manifests (`Deployment` and `Service`) located in the `k8s_pods/` directory.

### 1. Deploy the Application
To deploy Pi-hole to the cluster, run:
```bash
# Using the automated script
./deploy.sh

# OR manually
kubectl apply -f k8s_pods/
```

### 2. Access the Admin Interface

To access the web interface from your local machine, open a port-forward tunnel:
Bash

```
kubectl port-forward svc/pihole-service 8080:80
```

URL: http://localhost:8080/admin

### 3. Troubleshooting: Reset Password

If the password configured in the YAML (WEBPASSWORD) is ignored during the first boot, force it from inside the Pod:
Bash

#### 1. Find the Pi-hole Pod name

```
kubectl get pods
```

#### 2. Force the password to 'admin123'
```
kubectl exec -it <POD_NAME> -- pihole setpassword 'admin123'
```
## Phase 2: Observability (Prometheus & Grafana)

The monitoring stack is deployed via Helm (the Kubernetes package manager) to simplify the management of thousands of lines of YAML configuration.
### 1. Prepare Helm

Add the official Prometheus community repository to your machine:
```bash
helm repo add prometheus-community [https://prometheus-community.github.io/helm-charts](https://prometheus-community.github.io/helm-charts)
helm repo update
```
### 2. Deploy the Stack

Install the kube-prometheus-stack mega-package in a dedicated namespace called monitoring:
Bash

```bash
helm install mon-monitoring prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace
```

### 3. Retrieve Grafana's Secure Password

Helm generates a secure admin password and stores it in a Kubernetes "Secret". To decrypt and display it:

```bash
kubectl get secret --namespace monitoring mon-monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
(The default username is admin).

### 4. Access the Grafana Dashboard

Open a tunnel to the Grafana service:

```bash
kubectl port-forward svc/mon-monitoring-grafana 3000:80 --namespace monitoring
```
URL: http://localhost:3000

Once logged in, navigate to Dashboards > General > Kubernetes / Compute Resources / Cluster to view real-time metrics of your infrastructure.

### 5. Teardown (Clean up)

To cleanly destroy the infrastructure and free up resources:
```bash
# 1. Remove the monitoring stack (Helm)
helm uninstall mon-monitoring --namespace monitoring
kubectl delete namespace monitoring

# 2. Remove Pi-hole (YAML)
kubectl delete -f k8s_pods/
```