# Pepe Miner Bot

🌟 **Pepe Miner Bot** adalah skrip Ruby yang dirancang untuk mengotomatiskan proses klaim sinkronisasi scene untuk akun Pepe melalui API Hivehubs.

## 🚀 Fitur
- **Sinkronisasi Scene Otomatis**: Memproses scene type (0–19) untuk setiap akun.
- **Manajemen Token**: Mengambil dan memperbarui token secara otomatis menggunakan `init_data` atau refresh token.
- **Penanganan Error**: Mendeteksi scene type yang tidak valid dan menghentikan pemrosesan saat terjadi error.
- **Output Berwarna**: Menyediakan log yang jelas dengan kode warna untuk keberhasilan, error, dan pembaruan status.
- **Penundaan yang Dapat Dikonfigurasi**: Menyertakan penundaan 3 detik antar permintaan dan siklus 4 jam untuk pemrosesan ulang.

## 📋 Prasyarat
- Ruby 3.0 atau lebih tinggi
- File `data.txt` yang berisi string `init_data` (satu per baris) untuk akun Pepe Anda

## 🛠 Instalasi
1. **Klon Repositori**:
   ```bash
   git clone https://github.com/Yuurichan-N3/Pepe-Miner-Bot.git
   cd Pepe-Miner-Bot
   ```

2. **Instal Dependensi**:
   Instal gem Ruby yang diperlukan:
   ```bash
   gem install httparty colorize
   ```

3. **Siapkan `data.txt`**:
   Buat file `data.txt` di direktori proyek dan tambahkan string `init_data`, satu per baris. Contoh:
   ```
   query_id=AAFYST4gAwA...
   query_id=BBGXUT5hBxB...
   ```

## ▶️ Cara Penggunaan
1. Pastikan `data.txt` telah diisi dengan `init_data` yang valid.
2. Jalankan skrip:
   ```bash
   ruby bot.rb
   ```
3. Bot akan:
   - Membaca `init_data` dari `data.txt`.
   - Memproses setiap akun, mengambil token, dan mencoba sinkronisasi scene untuk `scene_type` 0–19.
   - Menunggu 3 detik antar permintaan scene dan 4 jam antar siklus.
   - Menampilkan log dengan kode warna (hijau untuk sukses, merah untuk error, kuning untuk status, biru untuk pembaruan siklus).

## 📂 Struktur File
- `bot.rb`: Skrip Ruby utama untuk bot.
- `data.txt`: File input untuk string `init_data` (buat secara manual).
- `README.md`: File dokumentasi ini.

## ⚠️ Catatan
- Skrip ini mengasumsikan endpoint dan header API Hivehubs tetap seperti yang ditentukan.
- Pastikan `data.txt` berisi `init_data` yang valid untuk menghindari error autentikasi.
- Jika scene type tidak valid, bot akan menghentikan pemrosesan untuk akun tersebut dan melanjutkan ke akun berikutnya.
- Untuk debugging, periksa pesan error di log untuk mengetahui penyebab kegagalan (misalnya, scene type tidak valid atau masalah token).

## 📜 Lisensi
Skrip ini didistribusikan untuk keperluan pembelajaran dan pengujian. Penggunaan di luar tanggung jawab pengembang.

Untuk update terbaru, bergabunglah di grup **Telegram**: [Klik di sini](https://t.me/sentineldiscus).

---

## 💡 Disclaimer
Penggunaan bot ini sepenuhnya tanggung jawab pengguna. Kami tidak bertanggung jawab atas penyalahgunaan skrip ini.
