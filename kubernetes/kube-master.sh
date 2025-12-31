#!/bin/bash

# ==========================================
# 1. DETEKSI IP PRIVATE OTOMATIS
# ==========================================
# Mengambil IP Private dari interface jaringan (biasanya eth0)
# Ini lebih aman daripada mengetik manual agar tidak salah input IP Public
IP_MASTER=$(hostname -I | awk '{print $1}')

echo "Mendeteksi IP Master: $IP_MASTER"

# ==========================================
# 2. INISIALISASI KUBERNETES MASTER
# ==========================================
# --apiserver-advertise-address: Wajib IP Private agar worker bisa connect
# --pod-network-cidr: 192.168.0.0/16 adalah default Calico
sudo kubeadm init --apiserver-advertise-address=$IP_MASTER --pod-network-cidr=192.168.0.0/16

# ==========================================
# 3. SETUP KUBE CONFIG (Agar bisa pakai kubectl)
# ==========================================
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# ==========================================
# 4. INSTALL CALICO NETWORK
# ==========================================
echo "Menginstall Calico Network..."
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/tigera-operator.yaml

# Download custom resources dulu untuk memastikan CIDR-nya cocok
curl https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/custom-resources.yaml -O

# (Opsional) Jika Anda ingin mengubah CIDR, edit file custom-resources.yaml di sini
# Tapi karena init anda pakai 192.168.0.0/16, default file ini sudah cocok.

kubectl create -f custom-resources.yaml

# ==========================================
# 5. CETAK PERINTAH JOIN (PENTING!)
# ==========================================
echo ""
echo "=========================================================="
echo "SETUP MASTER SELESAI!"
echo "Simpan perintah di bawah ini untuk dijalankan di Worker:"
echo "=========================================================="
kubeadm token create --print-join-command
echo "=========================================================="
