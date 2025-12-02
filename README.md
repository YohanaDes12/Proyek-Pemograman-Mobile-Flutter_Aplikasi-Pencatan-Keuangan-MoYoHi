# MoneyU-MoYoHi 💸

**MoneyU** adalah aplikasi pencatatan keuangan harian berbasis mobile yang dirancang untuk membantu pengguna mengelola pemasukan dan pengeluaran dengan mudah, aman, dan transparan.

Aplikasi ini merupakan hasil konversi dan pengembangan ulang menggunakan **Flutter**, menawarkan antarmuka yang modern (UI) dan pengalaman pengguna (UX) yang lebih responsif dibandingkan versi sebelumnya.

## 📱 Fitur Utama

Aplikasi ini dilengkapi dengan fitur-fitur esensial untuk manajemen keuangan pribadi:

* **🔐 Keamanan PIN (PIN Security)**
    * Saat pertama kali dibuka, pengguna wajib membuat PIN 6 digit.
    * Setiap kali aplikasi dibuka kembali, pengguna harus memasukkan PIN untuk menjaga privasi data keuangan.
* **🏠 Dashboard Informatif**
    * Menampilkan **Total Saldo** saat ini secara *real-time*.
    * Ringkasan total **Pemasukan** dan **Pengeluaran**.
* **📝 Pencatatan Transaksi (Input Mudah)**
    * Fitur **Tab Switcher** untuk berpindah cepat antara mode *Pemasukan* dan *Pengeluaran*.
    * Formulir input nominal, kategori (khusus pengeluaran), dan catatan tambahan.
* **📒 Buku Catatan (Riwayat)**
    * Melihat daftar riwayat transaksi yang telah dilakukan.
    * Indikator warna (Hijau untuk Pemasukan, Merah untuk Pengeluaran) untuk memudahkan pembacaan.
* **📊 Analisis Pengeluaran**
    * Visualisasi data menggunakan **Grafik Lingkaran (Pie Chart)** yang interaktif.
    * Rincian pengeluaran berdasarkan kategori beserta persentasenya.
    * Perhitungan total pengeluaran otomatis.

## 🛠 Bahasa & Teknologi yang Digunakan

Aplikasi ini dibangun menggunakan teknologi modern untuk pengembangan aplikasi mobile:

* **Bahasa Pemrograman:** [Dart](https://dart.dev/)
* **Framework:** [Flutter](https://flutter.dev/) (SDK >=3.0.0)
* **Arsitektur:** MVC (Model-View-Controller) pattern sederhana.

### Pustaka (Libraries) Utama:
* **`shared_preferences`**: Digunakan sebagai database lokal ringan untuk menyimpan PIN pengguna dan seluruh data transaksi secara offline di dalam perangkat.
* **`fl_chart`**: Digunakan untuk merender grafik lingkaran (Pie Chart) pada halaman Analisis.
* **`intl`**: Digunakan untuk memformat angka menjadi format mata uang Rupiah (IDR) dan format tanggal.

## 🚀 Cara Menjalankan Aplikasi (Instalasi)

Ikuti langkah-langkah berikut untuk menjalankan proyek ini di komputer Anda:

**Prasyarat:** Pastikan Flutter SDK sudah terinstal dan `flutter doctor` tidak menunjukkan error.

1.  **Clone atau Buka Proyek**
    Buka folder proyek ini di terminal atau VS Code.

2.  **Unduh Dependensi**
    Jalankan perintah berikut untuk mengunduh semua library yang dibutuhkan:
    ```bash
    flutter pub get
    ```

3.  **Siapkan Aset**
    Pastikan folder `assets/` sudah berisi gambar ikon (`ic_logo.png`, `ic_book.png`, dll) dan sudah terdaftar di `pubspec.yaml`.

4.  **Jalankan Aplikasi**
    Pastikan Emulator Android sudah menyala atau HP fisik tersambung, lalu ketik:
    ```bash
    flutter run
    ```

## 📖 Cara Menggunakan Aplikasi

1.  **Setup Awal:** Saat pertama kali membuka aplikasi, buat **PIN 6 digit** untuk mengamankan data Anda.
2.  **Login:** Masukkan PIN yang telah dibuat untuk masuk ke Dashboard.
3.  **Tambah Transaksi:**
    * Di halaman **Home**, pilih tab **"Pemasukan"** atau **"Pengeluaran"**.
    * Masukkan nominal uang.
    * (Jika Pengeluaran) Isi kategori, misal: "Makan", "Transport".
    * Klik **"SIMPAN TRANSAKSI"**.
4.  **Lihat Riwayat:** Klik menu **"Buku"** di navigasi bawah untuk melihat daftar semua transaksi.
5.  **Cek Analisis:** Klik menu **"Analisis"** untuk melihat grafik pengeluaran Anda agar bisa berhemat.

---
*Dibuat dengan ❤️ menggunakan Flutter.*