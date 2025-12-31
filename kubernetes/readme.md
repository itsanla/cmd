## Setup Izin Eksekusi

Salin dan jalankan perintah ini di terminal untuk mengaktifkan semua script:

```bash
chmod +x kube-config.sh kube-master.sh kube-storage.sh
```
```bash
./kube-config.sh   # (Di semua node)
```
```bash
./kube-master.sh   # (Di Master saja)
```
```bash
./kube-storage.sh  # (Di Master, setelah worker ready)
