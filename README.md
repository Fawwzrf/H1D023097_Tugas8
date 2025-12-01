# Toko Kita (Aplikasi Manajemen Produk)

**Toko Kita** adalah aplikasi mobile berbasis Flutter yang dirancang untuk manajemen inventaris produk (CRUD) yang lengkap. Aplikasi ini mengutamakan pengalaman pengguna dengan memberikan umpan balik visual (popup) yang jelas untuk setiap aksi sukses maupun gagal, serta sistem autentikasi yang aman.

---

## Galeri Antarmuka (UI)

### 1. Halaman Utama & Autentikasi
| Login Page | Registrasi Page | Dashboard Produk |
| :---: | :---: | :---: |
| ![Login Page](https://github.com/user-attachments/assets/db42fdab-c8cb-4918-b715-2cb2d45c116a) | ![Registrasi Page](https://github.com/user-attachments/assets/6a53d737-07da-46d5-b6b6-ff6c3a744beb) | ![List Produk](https://github.com/user-attachments/assets/a6668d4c-2646-403d-a9de-54c5381a4c9e) |

### 2. Manajemen Produk (CRUD)
| Detail Produk | Form Tambah | Form Ubah |
| :---: | :---: | :---: |
| ![Detail Produk](https://github.com/user-attachments/assets/58e543c4-c62f-4a11-b8a7-3b1acc66eb11) | ![Tambah Produk](https://github.com/user-attachments/assets/55fb4e9e-9954-426e-8360-39e1ed1f0d97) | ![Ubah Produk](https://github.com/user-attachments/assets/91cbb5a4-01b4-4d6c-8e67-1e70cf04c523) |

### 3. Notifikasi & Feedback User
Sistem memberikan respon visual instan menggunakan Dialog kustom.

| **Popup Berhasil (Sukses)** | **Popup Gagal (Warning)** | **Menu Logout** |
| :---: | :---: | :---: |
| <img width="348" height="727" alt="Popup Sukses" src="https://github.com/user-attachments/assets/af34c844-1b15-4fde-9f46-0071f2f6ed8a" /> | <img width="353" height="729" alt="Popup Gagal" src="https://github.com/user-attachments/assets/c98fc221-e497-4c4e-aa70-18c4072fd206" /> | <img width="345" height="729" alt="Menu Logout" src="https://github.com/user-attachments/assets/3692665a-ccec-4662-ba53-00adeb5cacc5" /> |
| *Muncul saat Registrasi/Simpan Data berhasil* | *Muncul saat Login salah atau validasi gagal* | *Akses melalui Side Menu (Drawer)* |

---

## Alur Proses & Penjelasan Kode

Berikut adalah detail teknis bagaimana setiap fitur bekerja di balik layar.

### 1. Proses Login & Feedback
Pengguna masuk ke dalam sistem dengan validasi keamanan.

**a. Input & Validasi**
* Pengguna mengisi Email dan Password.
* Tombol login memicu fungsi `_submit` yang memanggil `LoginBloc`.

**b. Penanganan Respon (Berhasil vs Gagal)**
Kode di bawah ini menunjukkan logika: jika API mengembalikan kode 200 (sukses), token disimpan. Jika tidak, muncul *Warning Dialog* (lihat screenshot Popup Gagal).

* **Kode Implementasi (`ui/login_page.dart`):**
    ```dart
    LoginBloc.login(
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    ).then((value) async {
        if (value.code == 200) {
          // JIKA BERHASIL: Simpan sesi & Pindah halaman
          await UserInfo().setToken(value.token.toString());
          await UserInfo().setUserID(int.parse(value.userID.toString()));
          Navigator.pushReplacement(..., ProdukPage());
        } else {
          // JIKA GAGAL (API menolak): Tampilkan WarningDialog
          showDialog(
            context: context,
            builder: (BuildContext context) => const WarningDialog(
              description: "Login gagal, silahkan coba lagi",
            ),
          );
        }
    }, onError: (error) {
        // JIKA ERROR (Koneksi/Server): Tampilkan WarningDialog
        showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
            description: "Terjadi kesalahan koneksi",
          ),
        );
    });
    ```

---

### 2. Manajemen Produk (CRUD) dengan Notifikasi
Setiap aksi manipulasi data (Tambah, Ubah, Hapus) memberikan umpan balik kepada pengguna.

**a. Tambah Data Produk**
Saat pengguna mengisi form dan menekan "SIMPAN", aplikasi mengirim data ke API.
* **Kode Implementasi (`ui/produk_form.dart`):**
    ```dart
    ProdukBloc.addProduk(produk: createProduk).then((value) {
      // Jika sukses, kembali ke halaman list (yang akan refresh otomatis)
      Navigator.of(context).push(...);
    }, onError: (error) {
      // Jika gagal, muncul popup warning
      showDialog(..., builder: (_) => const WarningDialog(description: "Simpan gagal"));
    });
    ```

**b. Hapus Produk (Delete)**
Proses ini memiliki lapisan keamanan ganda: Konfirmasi awal dan Notifikasi Sukses akhir.

1.  User menekan tombol Delete -> Muncul `AlertDialog` (Yakin hapus?).
2.  Jika pilih "Ya" -> Panggil API Delete.
3.  Jika API sukses -> Muncul `SuccessDialog` (lihat screenshot Popup Berhasil).

* **Kode Implementasi (`ui/produk_detail.dart`):**
    ```dart
    // 1. Logika Eksekusi Hapus
    bool result = await ProdukBloc.deleteProduk(id: int.parse(widget.produk!.id!));
    
    // 2. Tampilkan Popup Berhasil (SuccessDialog)
    if (result) {
      showDialog(
        context: context,
        builder: (BuildContext context) => SuccessDialog(
          description: "Produk berhasil dihapus",
          okClick: () {
            // Kembali ke list setelah user klik OK pada popup sukses
            Navigator.pushReplacement(..., ProdukPage());
          },
        ),
      );
    } else {
      // 3. Tampilkan Popup Gagal (WarningDialog)
      showDialog(..., builder: (_) => const WarningDialog(description: "Hapus gagal"));
    }
    ```

---

### 3. Proses Logout
Fitur untuk mengakhiri sesi pengguna secara aman.

**a. Tampilan & Aksi**
Tombol Logout terletak di dalam **Drawer** (Menu Samping) pada halaman List Produk (Lihat screenshot "Menu Logout" di atas).

**b. Logika Pembersihan Sesi**
Saat ditekan, aplikasi menghapus Token JWT dari penyimpanan lokal (`SharedPreferences`) agar pengguna tidak bisa masuk kembali tanpa login ulang.

* **Kode Implementasi (`ui/produk_page.dart`):**
    ```dart
    // Widget Drawer
    drawer: Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text('Logout'),
            trailing: const Icon(Icons.logout), // Ikon Logout
            onTap: () async {
              // Panggil BLoC untuk hapus sesi
              await LogoutBloc.logout().then((value) => {
                  // Arahkan paksa ke halaman Login & hapus history navigasi
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
                  ),
              });
            },
          ),
        ],
      ),
    ),
    ```

---

## Komponen Widget Kustom

Aplikasi ini menggunakan widget dialog kustom untuk menjaga konsistensi desain (lihat folder `lib/widget/`).

* **`WarningDialog`**: Menampilkan ikon/teks merah untuk kesalahan (Error/Gagal).
* **`SuccessDialog`**: Menampilkan teks hijau untuk keberhasilan operasi.

---

## Tech Stack

* **Bahasa**: Dart
* **Framework**: Flutter
* **API Client**: HTTP Package
* **State Management**: Manual BLoC Pattern
* **Local Storage**: Shared Preferences
