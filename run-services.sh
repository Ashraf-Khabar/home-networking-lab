# SRE Automation: Kill any existing port-forward processes to avoid port conflicts
killall kubectl 2>/dev/null || true

echo "Opening background network tunnels..."

# NGINX Ingress tunnel (Background)
nohup kubectl port-forward -n ingress-nginx svc/mon-receptionniste-ingress-nginx-controller 8080:80 > /dev/null 2>&1 &

# Grafana tunnel (Background)
nohup kubectl port-forward svc/mon-monitoring-grafana 3000:80 --namespace monitoring > /dev/null 2>&1 &

# Octant (Kubernetes Dashboard) tunnel (Background)
nohup kubectl port-forward -n kubernetes-dashboard svc/kubernetes-dashboard 8443:443 > /dev/null 2>&1 &

# Authentik tunnel (Background) - port 8081
nohup kubectl port-forward -n authentik svc/authentik-server 8081:80 > /dev/null 2>&1 &

# Adminer tunnel (Background) - port 8082

nohup kubectl port-forward -n databases svc/db-visualizer 8082:8080  > /dev/null 2>&1 &

# Wait 2 seconds to ensure tunnels are established
sleep 2

echo "==================================================================================="
echo "Make sure that hosts.txt files contains the names below (pihole.lab, ...)"
echo "YOUR SERVICES ARE READY:"
echo "Pi-hole (Via Ingress) : http://pihole.lab:8080/admin"
echo "Grafana Direct        : http://grafana.lab:3000/dashboards"
echo "Octant / K8s Dash     : https://octant.lab:8443"
echo "Authentik Direct      : http://authentic.lab:8081/if/flow/initial-setup/"
echo "Adminer Direct        : http://localhost:8082"
echo "==================================================================================="