To monitor your Kubernetes (k8s) cluster metrics using Prometheus and Grafana installed on an Ubuntu server, follow these steps:

---

## 1. **Install Prometheus on the Ubuntu Server**
1. **Update packages**:
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

2. **Download Prometheus**:
   Visit the [Prometheus download page](https://prometheus.io/download/) or use the following commands to download the latest release:
   ```bash
   wget https://github.com/prometheus/prometheus/releases/download/v2.46.0/prometheus-2.46.0.linux-amd64.tar.gz
   tar -xvzf prometheus-2.46.0.linux-amd64.tar.gz
   cd prometheus-2.46.0.linux-amd64
   ```

3. **Move binaries to `/usr/local/bin`**:
   ```bash
   sudo mv prometheus /usr/local/bin/
   sudo mv promtool /usr/local/bin/
   ```

4. **Create configuration files and directories**:
   ```bash
   sudo mkdir /etc/prometheus
   sudo mkdir /var/lib/prometheus
   sudo cp prometheus.yml /etc/prometheus/
   ```

5. **Set up a Prometheus service**:
   Create a systemd service file:
   ```bash
   sudo nano /etc/systemd/system/prometheus.service
   ```
   Add the following:
   ```ini
   [Unit]
   Description=Prometheus Monitoring
   Wants=network-online.target
   After=network-online.target

   [Service]
   User=root
   ExecStart=/usr/local/bin/prometheus \
     --config.file=/etc/prometheus/prometheus.yml \
     --storage.tsdb.path=/var/lib/prometheus

   [Install]
   WantedBy=multi-user.target
   ```

6. **Start Prometheus**:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl start prometheus
   sudo systemctl enable prometheus
   ```

7. **Verify installation**:
   Access Prometheus via `http://<Ubuntu_Server_IP>:9090`.

---

## 2. **Install Grafana on the Ubuntu Server**

1. **Install Grafana**:
   ```bash
   sudo apt-get install -y apt-transport-https software-properties-common wget
   sudo mkdir -p /etc/apt/keyrings/
   wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
   echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
   echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com beta main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
   # Updates the list of available packages
   sudo apt-get update
   # Installs the latest OSS release:
   sudo apt-get install grafana
   # Installs the latest Enterprise release:
   sudo apt-get install grafana-enterprise
   ```

2. **Start Grafana service**:
   ```bash
   sudo systemctl start grafana-server
   sudo systemctl enable grafana-server
   sudo systemctl status grafana-server
   ```

3. **Access Grafana**:
   Open `http://<Ubuntu_Server_IP>:3000` in your browser. Default credentials:
   - **Username**: `admin`
   - **Password**: `admin` (You’ll be prompted to change this upon first login.)

---

## 3. **Set Up Prometheus to Monitor Kubernetes**
1. **Deploy Prometheus Node Exporter on Kubernetes**:
   - Install using Helm:
     ```bash
     helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
     helm repo update
     helm install prometheus prometheus-community/prometheus --namespace monitoring --create-namespace
     ```
   - This will deploy Prometheus and expose metrics endpoints for scraping.

2. **Edit Prometheus Configuration on the Ubuntu Server**:
   Add your Kubernetes Prometheus service IP/endpoint to `/etc/prometheus/prometheus.yml`:
   ```yaml
   scrape_configs:
     - job_name: 'kubernetes'
       static_configs:
         - targets: ['<K8s-Prometheus-Service-IP>:9090']
   ```

3. **Reload Prometheus**:
   ```bash
   sudo systemctl restart prometheus
   ```

---

## 4. **Configure Grafana to Visualize Kubernetes Metrics**
1. **Add Prometheus as a data source in Grafana**:
   - Navigate to `Settings` → `Data Sources` → `Add data source`.
   - Select Prometheus and set the URL as `http://<Ubuntu_Server_IP>:9090`.

2. **Import Kubernetes dashboards**:
   - Search Grafana's dashboard marketplace or import prebuilt Kubernetes monitoring dashboards (e.g., dashboard ID `315` for K8s cluster monitoring).

---

### Optional: Install Prometheus Operator on Kubernetes
Using the Prometheus Operator Helm chart provides a more integrated and automated setup:
```bash
helm install prometheus-operator prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace
```
Update the Prometheus service to expose metrics to your Ubuntu server.

