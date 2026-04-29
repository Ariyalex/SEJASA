# SEJASA - Sedekah Jasa

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)

**SEJASA** adalah platform berbasis Flutter yang dirancang untuk membangun ekosistem digital yang menghubungkan pemilik keahlian (relawan) dengan lembaga yang membutuhkan bantuan teknis secara fleksibel. Aplikasi ini mengusung misi untuk mentransformasi orientasi sedekah di masyarakat dari sekadar bantuan materi menjadi bantuan berbasis kompetensi dan intelektual.

## Tujuan Pengembangan
1. **Ekosistem Intelektual**: Menghubungkan ahli dengan lembaga sosial/agama yang membutuhkan bantuan teknis.
2. **Transformasi Sedekah**: Menggeser paradigma sedekah materi menjadi sedekah kompetensi.
3. **Portofolio Relawan**: Wadah bagi lulusan baru (*fresh graduates*) untuk mengaplikasikan ilmu sekaligus membangun portofolio profesional melalui kegiatan sosial.

## Manfaat
- **Bagi Lembaga**: Menemukan relawan kompeten secara fleksibel dan memperluas jangkauan pencarian bantuan.
- **Bagi Relawan**: Mendapatkan pengalaman kerja nyata, membangun relasi profesional, dan berkontribusi sosial.
- **Bagi Pengembang**: Sarana pengembangan skill teknis dan pengayaan portofolio.

## Fitur Utama
- **Login & Registrasi**: Autentikasi pengguna (Lembaga & Relawan).
- **Dashboard**: Pusat informasi proyek dan rekomendasi.
- **Algoritma Matching**: Fitur unggulan untuk mencocokkan relawan dengan proyek terdekat atau yang paling relevan.
- **Manajemen Proyek**: Fitur untuk membuat tawaran proyek (Lembaga) dan mengambil proyek (Relawan).
- **Sistem Rating**: Penilaian bintang dan review dari kedua belah pihak setelah proyek selesai.
- **Profil Pengguna**: Informasi detail pengguna dan rekam jejak aktivitas.
- **Export Portofolio**: Konversi hasil pekerjaan menjadi dokumen PDF untuk keperluan profesional.
- **Notifikasi**: Informasi real-time terkait status proyek.

## Ruang Lingkup & Batasan
- **Platform**: Android.
- **Target Pengguna**: Masyarakat umum, pengurus lembaga, pelajar, dan *fresh graduates*.
- **Di Luar Lingkup**: Sistem pembayaran dan pelacakan lokasi (*tracking*) relawan secara real-time tidak tersedia di versi ini.

## Tautan Penting
- **Dokumentasi API (Postman)**: [Lihat di Postman](https://www.postman.com/teknohole/workspace/sejasa)
- **Repository Backend**: [GitHub SEJASA BE](https://github.com/Arbath/sejasa_be)
- **Desain UI/UX (Figma)**: [Figma Mockup](https://www.figma.com/design/RsLDeB3YRFRSMU7jKCWt7C/mockup-ui?node-id=0-1&t=aLqQNLo2Qtvp5lid-1)

## Cara Kerja Aplikasi
1. **Penawaran**: Lembaga atau perorangan membuat pengumuman proyek sosial.
2. **Pencocokan**: Sistem memberikan rekomendasi relawan/proyek berdasarkan lokasi terdekat.
3. **Eksekusi**: Relawan memilih dan mengerjakan proyek yang diinginkan.
4. **Review**: Pemberian testimoni dan rating bintang setelah proyek selesai.
5. **Reward**: Relawan mendapatkan pengalaman yang dapat diekspor menjadi portofolio PDF.

## Memulai
### Prasyarat
Pastikan Anda sudah menginstal Flutter SDK di mesin Anda.

### Instalasi
1. Clone repository ini:
   ```bash
   git clone https://github.com/Ariyalex/SEJASA.git
   ```
2. Masuk ke direktori proyek:
   ```bash
   cd SEJASA
   ```
3. Ambil dependencies:
   ```bash
   flutter pub get
   ```
4. Jalankan aplikasi:
   ```bash
   flutter run
   ```

