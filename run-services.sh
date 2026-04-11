# SRE Automation: Kill any existing port-forward processes to avoid port conflicts
killall kubectl 2>/dev/null || true

echo "Opening background network tunnels..."

# NGINX Ingress tunnel (Background)
nohup kubectl port-forward -n ingress-nginx svc/mon-receptionniste-ingress-nginx-controller 8080:80 > /dev/null 2>&1 &

# Grafana tunnel (Background)
nohup kubectl port-forward svc/mon-monitoring-grafana 3000:80 --namespace monitoring > /dev/null 2>&1 &

# Ortant tunnel (Background)
nohup kubectl port-forward -n kubernetes-dashboard svc/kubernetes-dashboard 8443:443 > /dev/null 2>&1 &

# Wait 2 seconds to ensure tunnels are established
sleep 2


echo "=========================================================="
echo "Make sure that hosts.txt files contains the names below (pihole.lab, ...)"
echo "YOUR SERVICES ARE READY:"
echo "Pi-hole (Via Ingress) : http://pihole.lab:8080/admin"
echo "Grafana Direct        : http://grafana.lab:3000/dashboards"
echo "Ortant Direct         : https://ortant.lab:8443"
echo "=========================================================="