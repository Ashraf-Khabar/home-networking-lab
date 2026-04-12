# HOME NETWORKING LAB (SRE)

## TECHNICAL ARCHITECTURE
The infrastructure is designed using a local "Cloud-Native" model, ensuring 
high availability and strict service isolation.

1. ENTRY LAYER (INGRESS)
   - Controller: NGINX Ingress Controller.
   - Role: Single point of entry (Port 80/443). Manages host-based routing 
     (Virtual Hosting) to internal cluster services based on local DNS.

2. IDENTITY LAYER (SSO)
   - Service: Authentik.
   - Role: Centralized identity provider. Instead of managing passwords per 
     application, Authentik validates identity via OIDC/SAML before granting 
     access to downstream services like Grafana.

3. OBSERVABILITY LAYER
   - Prometheus: Scrapes and stores performance metrics from Pods and Nodes.
   - Grafana: Data visualization and dashboards connected to Authentik SSO.

4. NETWORK SERVICES LAYER
   - Pi-hole: Recursive DNS server with network-wide ad-blocking capabilities.
   - Uptime Kuma: External service monitoring and alerting.

---

## LOCAL DNS CONFIGURATION (hosts file)
To route traffic correctly to the NGINX Ingress, you must map your local 
domains to the local loopback address. 

Add the following line to your hosts file

### For Windows

```sh
C:\\Windows\\System32\\drivers\\etc\\hosts
```

### For Linux/Mac
```sh
/etc/hosts
```
and chage the configiration names for localhosts :

```bash
127.0.0.1    pihole.lab grafana.lab kuma.lab octant.lab authentic.lab=
```

---

## PROJECT STRUCTURE
- /kube-objects/ : YAML Manifests (Services, Deployments, Ingress).
- /shell-scripts/ : Automation scripts (Helm & Native Kubernetes).
- .env : Environment variables and secrets (IGNORED BY GIT).

---

## DEPLOYMENT COMMANDS
1. Deploy the entire infrastructure:
```bash
./deploy-infra.sh
```

2. Activate local access (Tunnels):
```bash
./run-services.sh
```
---

## SERVICE ACCESS LINKS
Once the tunnels are running, access your services here:

- Pi-hole (Via Ingress) : http://pihole.lab:8080/admin
- Grafana Direct        : http://grafana.lab:3000/dashboards
- Octant / K8s Dash     : https://octant.lab:8443
- Authentik Direct      : http://authentic.lab:8081/if/flow/initial-setup/

---

## APPLIED SRE BEST PRACTICES
- **Idempotency** : Helm scripts utilize ```upgrade --install``` .
- **Security** : Secrets injection via .env files (never hardcoded).
- **Fail-Fast** : Strict error handling using ```set -e``` in Bash scripts.
- **Vendor Bypass** : Replaced broken Helm charts with official resilient alternatives.