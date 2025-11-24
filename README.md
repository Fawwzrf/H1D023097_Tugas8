# Toko Kita (Aplikasi Manajemen Produk)

Aplikasi mobile sederhana berbasis Flutter untuk manajemen produk (CRUD) yang mencakup fitur Login, Registrasi, dan pengelolaan data barang.

## Screenshot Aplikasi

| Login Page | Registrasi Page | List Produk |
| :---: | :---: | :---: |
| ![WhatsApp Image 2025-11-24 at 19 13 421](https://github.com/user-attachments/assets/db42fdab-c8cb-4918-b715-2cb2d45c116a)
| ![WhatsApp Image 2025-11-24 at 19 13 42](https://github.com/user-attachments/assets/6a53d737-07da-46d5-b6b6-ff6c3a744beb)
 | <img width="344" height="769" alt="Screenshot 2025-11-24 190635" src="https://github.com/user-attachments/assets/a6668d4c-2646-403d-a9de-54c5381a4c9e" />


| Detail Produk | Form Tambah/Ubah |
| :---: | :---: |
| <img width="349" height="763" alt="Screenshot 2025-11-24 190646" src="https://github.com/user-attachments/assets/58e543c4-c62f-4a11-b8a7-3b1acc66eb11" />
| <img width="353" height="777" alt="Screenshot 2025-11-24 190806" src="https://github.com/user-attachments/assets/55fb4e9e-9954-426e-8360-39e1ed1f0d97" /> <img width="342" height="784" alt="Screenshot 2025-11-24 190818" src="https://github.com/user-attachments/assets/91cbb5a4-01b4-4d6c-8e67-1e70cf04c523" />

---

## Penjelasan Struktur Kode (`lib/`)

Berikut adalah penjelasan fungsi dari setiap file yang terdapat di dalam folder `lib`:

### 1. Entry Point
* **`main.dart`**: 
    * File utama yang dijalankan pertama kali oleh Flutter.
    * Berisi widget `MyApp` yang mengatur tema aplikasi (`MaterialApp`) dan menentukan halaman awal yang akan dimuat (saat ini diset ke `ProdukPage`).

### 2. Model (`lib/model/`)
Folder ini berisi representasi objek data dari JSON respons API.
* **`login.dart`**: Model untuk menampung respon saat login (seperti `code`, `status`, `token`, `userID`, dan `userEmail`).
* **`registrasi.dart`**: Model untuk menampung respon saat melakukan registrasi akun baru.
* **`produk.dart`**: Model untuk objek Produk yang berisi atribut `id`, `kodeProduk`, `namaProduk`, dan `hargaProduk`.

### 3. UI / Tampilan (`lib/ui/`)
Folder ini berisi halaman-halaman antarmuka pengguna.
* **`registrasi_page.dart`**:
    * Halaman form pendaftaran pengguna baru.
    * Memiliki validasi input untuk Nama (min 3 karakter), Email (format email), dan Password (min 6 karakter & konfirmasi password harus sama).
* **`login_page.dart`**:
    * Halaman untuk autentikasi pengguna.
    * Berisi input Email dan Password dengan validasi dasar.
    * Memiliki navigasi menuju halaman Registrasi jika pengguna belum punya akun.
* **`produk_page.dart`**:
    * Halaman utama yang menampilkan daftar produk.
    * Menggunakan `ListView` untuk menampilkan `Card` berisi ringkasan info produk.
    * Memiliki *Drawer* (menu samping) untuk fitur Logout.
    * Terdapat tombol (+ Add) untuk menambah produk baru.
* **`produk_detail.dart`**:
    * Halaman untuk melihat rincian lengkap sebuah produk.
    * Menampilkan Kode, Nama, dan Harga produk.
    * Menyediakan tombol navigasi untuk **Edit** (pindah ke `ProdukForm`) dan tombol **Delete** (menghapus produk).
* **`produk_form.dart`**:
    * Halaman formulir yang bersifat dinamis (bisa untuk **Tambah** atau **Ubah**).
    * Jika halaman menerima parameter data produk, maka form akan terisi otomatis (Mode Edit).
    * Jika tidak ada parameter, form akan kosong (Mode Tambah Baru).

### 4. BLoC / Logic (`lib/bloc/`)
Folder ini menangani logika bisnis dan komunikasi dengan API.
* **`produk_bloc.dart`**:
    * Berisi fungsi-fungsi *static* untuk melakukan request HTTP ke API (`https://contoh-api.com/api/produk`).
    * `getProduks()`: Mengambil daftar produk (GET).
    * `addProduk()`: Menambah produk baru (POST).
    * `updateProduk()`: Mengupdate data produk (PUT).
    * `deleteProduk()`: Menghapus data produk (DELETE).

### 5. Widget (`lib/widget/`)
Folder ini berisi komponen widget yang dapat digunakan kembali (reusable).
* **`warning_dialog.dart`**:
    * Widget kustom untuk menampilkan *Pop-up Dialog* peringatan sederhana kepada pengguna.

---
