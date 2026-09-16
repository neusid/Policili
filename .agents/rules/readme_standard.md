# Standar Pembuatan README.md Proyek

Setiap pembuatan atau restrukturisasi berkas `README.md` harus mengikuti standar baku berikut agar dokumentasi komprehensif, informatif, dan memiliki estetika profesional kelas enterprise.

## 1. Struktur Wajib & Hirarki Seksi

Setiap `README.md` harus memiliki 9 komponen berikut secara berurutan:

1. **Header & Branding**:
   - Judul dengan emoji: `# [Emoji] [Nama Proyek] ([Sub-nama/Alias])`
   - Logo rata tengah:
     ```html
     <p align="center">
       <img src="path/to/logo.png" alt="Project Logo" width="160" />
     </p>
     ```
   - Tagline proyek rata tengah (*bold* & *italic*).
   - Badges Shields.io (`style=for-the-badge`) untuk teknologi inti, framework, database, dan platform.
   - Garis pemisah horizontal `---`.

2. **Tentang Proyek (About)**:
   - Paragraf ringkasan eksekutif: apa itu aplikasi, masalah yang diselesaikan, integrasi teknologi (e.g. IoT, AI, Cloud), dan target pengguna.

3. **Fitur Utama (Key Features)**:
   - Dikelompokkan per modul/fitur dengan ikon emoji yang relevan.
   - Poin-poin spesifik mengenai kapabilitas sistem.

4. **Arsitektur Sistem (System Architecture)**:
   - Paparan pola arsitektur yang digunakan (Clean Architecture, MVC, MVVM, dll.).
   - **Flowchart Layer (Mermaid)**: Menggambarkan hubungan antar-layer. Wajib mematuhi `mermaid_syntax.md` (gunakan `-.->|Implements|`, hindari `<|..|`).
   - **Sequence Diagram (Mermaid)**: Menjelaskan siklus alur data terpenting (*happy path*) dari interaksi pengguna hingga layanan eksternal dengan `autonumber`.
   - Penjelasan deskriptif tiap layer dan tanggung jawabnya.

5. **Teknologi & Dependensi (Tech Stack Table)**:
   - Sajikan dalam bentuk tabel Markdown dengan kolom:
     | Kategori | Teknologi / Pustaka | Deskripsi |
   - Tautkan nama library langsung ke dokumentasi resmi atau package registry (e.g., pub.dev, npm, pypi).

6. **Struktur Direktori (Directory Structure)**:
   - Sajikan dalam blok kode `text` dengan tree diagram beranotasi fungsi direktori.

7. **Panduan Memulai (Getting Started)**:
   - **Prasyarat**: Daftar versi SDK, compiler, emulator/perangkat yang dibutuhkan.
   - **Langkah Instalasi**: Perintah CLI step-by-step dari `git clone`, instalasi dependensi, konfigurasi file `.env` / credentials, hingga menjalankan aplikasi di mode dev.

8. **Alur Penggunaan (Usage / User Journey)**:
   - Langkah demi langkah alur operasional aplikasi saat digunakan oleh pengguna akhir.

9. **Lisensi & Hak Cipta (License & Credits)**:
   - Penjelasan lisensi perangkat lunak dan kredit tim pengembang.

## 2. Standar Format & Estetika
- **Pemisah Antar-Seksi**: Selalu gunakan `---` di antara seksi utama untuk keterbacaan yang optimal.
- **Diagram Mermaid**: Pastikan semua sintaks Mermaid lulus validasi render GitHub Markdown (lihat `mermaid_syntax.md`).
- **Bahasa**: Gunakan bahasa yang konsisten (Bahasa Indonesia baku atau Bahasa Inggris teknis profesional) sesuai preferensi proyek.
