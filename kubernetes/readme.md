## Setup Izin Eksekusi

Salin dan jalankan perintah ini di terminal untuk mengaktifkan semua script:

```bash
chmod +x kube-config.sh kube-master.sh kube-storage.sh

./kube-config.sh   # (Di semua node)
./kube-master.sh   # (Di Master saja)
./kube-storage.sh  # (Di Master, setelah worker ready)
