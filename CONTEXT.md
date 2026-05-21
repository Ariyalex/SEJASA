# Project Context: Sejasa

Dokumen ini memberikan panduan mendalam mengenai arsitektur, teknologi, dan pola penulisan kode yang digunakan dalam proyek Sejasa. Dokumen ini dirancang agar developer baru dapat memahami seluruh detail sistem dengan cepat.

---

## 1. Tech Stack & Dependencies Utama

Aplikasi ini dibangun menggunakan Flutter dengan fokus pada modularitas, keandalan, dan skalabilitas tinggi. Berikut rincian pustaka utama yang digunakan:

- **Framework Core:** Flutter (SDK `^3.10.0-290.4.beta` / Dart SDK pendukung).
- **State Management:**
  - `flutter_bloc` (v9.1.1) untuk pemisahan logika bisnis dari UI.
  - `bloc_concurrency` (v0.3.0) untuk manajemen pemrosesan event secara konkuren (seperti `droppable()`).
  - `flutter_hooks` (v0.21.3+1) untuk manajemen state lokal widget yang lebih clean tanpa boilerplate `StatefulWidget`.
- **Routing:** `go_router` (v17.2.2) dengan struktur navigasi terpusat, dukungan sub-routing, redirection guard, dan transisi layar.
- **Networking & API:**
  - `dio` (v5.9.2) sebagai HTTP Client utama dengan custom interceptor.
  - `connectivity_plus` (v7.1.1) untuk mendeteksi status koneksi internet sebelum melakukan HTTP Request.
- **Dependency Injection:** `get_it` (v9.2.1) sebagai Service Locator untuk pendaftaran dependensi secara global.
- **Real-time / Socket:** `web_socket_channel` (v3.0.3) untuk komunikasi dua arah pada modul chat.
- **Local Storage:** `shared_preferences` (v2.5.5) untuk data persistensi ringan (seperti token akses, token refresh, dan histori pencarian).
- **UI & Premium Aesthetics:**
  - `flex_color_scheme` (v8.4.0) untuk manajemen tema (Light & Dark) yang konsisten.
  - `skeletonizer` (v2.1.3) untuk efek loading berkilau (shimmer) otomatis yang mengikuti bentuk layout widget asli.
  - `lucide_icons_flutter` (v3.1.13) sebagai pustaka icon set modern.
  - `toastification` (v3.2.0) untuk notifikasi in-app toast yang interaktif.
  - `flutter_map` (v8.3.0) & `latlong2` (v0.9.1) untuk visualisasi lokasi proyek dan navigasi peta berbasis OpenStreetMap.
  - `wolt_modal_sheet` (v0.11.0) untuk dialog bottom sheet multi-halaman yang fleksibel.
  - `flutter_quill` (v11.5.0) sebagai Rich Text Editor untuk deskripsi proyek yang membutuhkan format tulisan tebal/miring/list.
  - `persistent_bottom_nav_bar_v2` (v6.3.2) untuk manajemen navigasi bawah (bottom navigation) yang persisten antar layar tab.
- **Location Services:** `geolocator` (v14.0.2) untuk mendeteksi GPS pengguna dan `geocoding` (v4.0.0) untuk konversi koordinat GPS menjadi alamat fisik (reverse geocoding).
- **Utilitas Tambahan:** `equatable` (v2.0.8) untuk perbandingan objek (value equality), `flutter_dotenv` (v6.0.1) untuk membaca variabel lingkungan dari `.env`, dan `uuid` (v4.5.3) untuk pembuatan ID unik lokal.

---

## 2. Arsitektur Proyek (Deep-Dive)

Proyek ini mengadopsi modifikasi **Clean Architecture** yang disesuaikan dengan ekosistem Flutter serta dikombinasikan dengan **Feature-Driven Design** pada layer modul presentasi. Hal ini menjaga agar kode inti bisnis tidak terikat pada framework eksternal dan mempermudah pengujian unit.

```
lib/
│
├── core/               # Infrastruktur global & backbone aplikasi
├── domain/             # Layer Bisnis Murni (Entitas, Interface Repositori)
├── data/               # Layer Data (Model, Payload, Implementasi Repositori, Provider)
├── modules/            # Layer UI & Presentasi Terbagi per Fitur (Feature Modules)
├── main.dart           # Titik masuk utama aplikasi (Entrypoint)
└── my_app.dart         # Konfigurasi widget teratas (Theme, Router, Global Providers)
```

### 2.1. `lib/core/` (The Backbone)
Menyimpan fungsionalitas utilitas global yang digunakan bersama oleh berbagai modul.

- **`config/`**:
  - `app_config.dart`: Menyimpan konfigurasi global seperti `baseUrl` dan `timeout` request yang bersumber dari `.env`.
- **`di/`**:
  - `dependency_injection.dart`: Berisi kelas `DependencyInjection` untuk mendaftarkan singleton asinkron (seperti `StorageService`, `ApiService`, `LocationService`) dan mendaftarkan BLoC/Repository ke `GetIt`. Memiliki flag `isMocking` untuk mengganti implementasi data provider remote menjadi mock data lokal secara instan.
  - `app_providers.dart`: Berisi daftar `RepositoryProvider` dan `BlocProvider` tingkat global yang langsung di-inject di widget `MyApp`.
- **`errors/`**:
  - `api_exceptions.dart`: Definisi kelas error custom seperti `ApiException`, `NetworkException`, dan `ServerException` untuk membungkus exception dari layer Dio.
- **`routes/`**:
  - `app_router.dart`: Menginisialisasi `GoRouter` dengan rute awal `/splash`. Memiliki skema **Redirect Guard** pintar untuk mendeteksi status autentikasi pengguna secara reaktif (`refreshListenable` yang terikat pada stream `AuthBloc`), menjaga agar rute privat terlindungi, serta membebaskan rute publik (seperti `/guest`, `/login`, `/register`, `/search`).
  - `route_named.dart`: Menyimpan nama konstanta rute (misalnya `RouteNamed.splash`, `RouteNamed.mainTab`, `RouteNamed.chat`).
- **`services/`**:
  - `api_service.dart`: Wrapper Dio yang canggih dengan fitur pencegahan request duplikat (`_pendingRequests` tracker), deteksi koneksi internet secara real-time lewat `ConnectivityService`, penambahan header token otorisasi secara otomatis, interceptor log, dan **Automated Token Refresh (Refresh Token Rotation)** di mana jika terjadi error 401 Unauthorized, sistem akan secara otomatis memanggil API `/refresh` menggunakan refresh token yang tersimpan lalu melakukan retry request asli secara transparan. Jika refresh gagal, user akan diarahkan keluar (auto-logout).
  - `connectivity_service.dart`: Mengintegrasikan `connectivity_plus` untuk memeriksa ketersediaan koneksi internet secara asinkron.
  - `location_service.dart`: Menangani pengambilan koordinat GPS dengan alur request permission yang ramah pengguna (menampilkan dialog penjelasan terlebih dahulu), membuka pengaturan OS jika diblokir permanen, serta menangani reverse geocoding untuk mengubah koordinat `LatLng` menjadi nama jalan/wilayah.
  - `socket_service.dart`: Wrapper `WebSocketChannel` dengan fitur auto-reconnect (mencoba terhubung kembali dalam jeda 5 detik jika koneksi terputus) dan menyediakan broadcast stream untuk ditangkap oleh BLoC.
  - `storage_service.dart`: Abstraksi pembacaan, penulisan, dan penghapusan data persistensi menggunakan `SharedPreferences`.
- **`theme/`**:
  - `app_theme.dart`: Mendefinisikan warna utama, tipografi, dan gaya tombol untuk Light Mode dan Dark Mode menggunakan konfigurasi `flex_color_scheme`.
- **`utils/`**:
  - `log_utils.dart` (Wrapper Logger): Utilitas untuk melakukan logging terformat (`LogUtils.d()`, `LogUtils.i()`, `LogUtils.w()`, `LogUtils.e()`) yang dapat dinonaktifkan secara otomatis saat aplikasi naik ke tahap produksi (release mode).
- **`widgets/`**: Reusable component global yang dioptimalkan dengan estetika premium:
  - `my_text_field.dart` & `my_dropdown_field.dart`: Form field custom dengan validasi visual yang menarik.
  - `my_filled_button.dart` & `my_outline_button.dart`: Tombol berdesain modern dengan efek umpan balik visual yang responsif.
  - `my_tab_chip.dart` & `my_visual_chip.dart`: Chip interaktif untuk pilihan filter kategori.
  - `project_item_widget.dart`: Card visual utama untuk menampilkan data proyek, lengkap dengan progres kuota partisipan, rating, kategori, dan detail jarak lokasi.
  - `project_location_picker.dart` & `global_location_picker_sheet.dart`: Peta interaktif menggunakan `flutter_map` untuk memilih titik proyek secara presisi di peta.
  - `project_location_view_sheet.dart`: Lembar detail lokasi proyek memanfaatkan Wolt Modal Sheet dan OpenStreetMap untuk menampilkan posisi proyek, posisi user saat ini, garis pembanding (`Polyline`), serta kalkulasi jarak nyata secara instan.
- **`wrappers/`**:
  - `pagination_result.dart`: Membungkus data berhalaman dari backend (`PaginatedResult<T>`) lengkap dengan metadata pagination (`currentPage`, `totalPages`, `totalItems`).

---

### 2.2. `lib/domain/` (The Business Logic)
Layer paling bersih dan murni. Tidak boleh mengimpor pustaka UI Flutter atau dependensi eksternal dari layer data.

- **`entities/`**: Objek bisnis murni yang immutable.
  - `user_entity.dart`: Menyimpan profil pengguna (nama, email, rating, kordinat lokasi, alamat fisik, detail skill).
  - `project_entity.dart`: Menyimpan seluruh informasi proyek (ID, nama, alamat, koordinat, rating proyek, status proyek, kuota partisipan, kategori, persyaratan, hashtag, serta data pemilik proyek). Memiliki metode `dummyProject()` untuk keperluan rendering skeletonizer.
  - `project_category_entity.dart`: Kategori proyek (ID, nama, deskripsi, ikon).
  - `skill_entity.dart`: Keahlian pengguna (ID, nama).
  - `chat_entity.dart`: Entitas pesan chat tunggal (ID, ID pengirim/penerima, pesan teks, timestamp, flag kepemilikan pesan).
- **`repositories/`**: Kontrak antarmuka (Interface) abstrak yang mendefinisikan operasi data.
  - `auth_repository.dart`, `chat_repository.dart`, `project_repository.dart`, `user_repository.dart`.
- **`providers/`**: Kontrak antarmuka sumber data.
  - `remote_auth_provider.dart`, `remote_project_provider.dart`, `remote_user_provider.dart`, `chat_socket_provider.dart`.
- **`value_objects/`**: Definisi tipe data spesifik berbasis enum yang mempermudah integrasi warna UI.
  - `project_status.dart`: Enum status proyek (`hiring`, `going`, `pending`, `cancled`, `completed`) dengan helper `getTextColor()` dan `getBackgroundColor()` yang langsung menyesuaikan dengan tema aplikasi.
  - `gender_type.dart`, `project_filter_type.dart`, `sort_project_type.dart`.

---

### 2.3. `lib/data/` (The Implementation)
Layer yang bertanggung jawab mengimplementasikan kontrak domain dan menyajikan data nyata ke aplikasi.

- **`models/`**: Objek Data Transfer Object (DTO) yang mewarisi (extends) entitas domain dan dilengkapi metode parsing JSON.
  - `user_model.dart`, `project_model.dart`, `project_category_model.dart`, `skill_model.dart`, `chat_model.dart`.
- **`payloads/`**: Kelas khusus penampung data untuk body request API.
  - `register_payload.dart`: Payload pendaftaran user baru.
  - `project_create_payload.dart` & `project_update_payload.dart`: Payload pembuatan/pembaruan proyek.
  - `profile_update_payload.dart` & `profile_skill_update_payload.dart`: Payload pembaruan profil dan penyesuaian skill pengguna.
- **`providers/`**:
  - **`remote/`**: Menggunakan `ApiService` untuk berkomunikasi dengan REST API server asli atau `SocketService` untuk WebSocket (`remote_auth_provider_impl.dart`, `remote_project_provider_impl.dart`, `remote_user_provider_impl.dart`, `chat_socket_provider.dart`).
  - **`mock/`**: Implementasi lokal offline menggunakan dummy data statis (`mock_user_provider.dart`, `mock_project_provider.dart`, `mock_chat_socket_provider.dart`). Sangat berguna untuk pengembangan independen tanpa bergantung pada backend.
- **`repositories/`**: Implementasi repositori nyata yang mengoordinasikan data dari remote maupun mock provider (`auth_repository_impl.dart`, `chat_repository_impl.dart`, `project_repository_impl.dart`, `user_repository_impl.dart`).

---

### 2.4. `lib/modules/` (The Feature Modules)
Layer UI/Presentasi yang diorganisasi per fitur. Setiap folder modul bersifat otonom, berisi manajemen state (BLoC) dan halaman UI-nya sendiri.

- **`splash/`**:
  - `SplashScreen`: Layar pemuatan awal yang secara reaktif memeriksa status koneksi jaringan (`ConnectivityService`), menunggu kesiapan pendaftaran dependensi di `GetIt`, memvalidasi otentikasi sesi aktif (`AuthBloc`), lalu mengarahkan user secara mulus ke `mainTab` (jika sudah masuk) atau dashboard publik `/guest`.
- **`auth/`**:
  - BLoC menangani event `AuthCheckRequested` (auto-login), `AuthLoginRequested`, `AuthRegisterRequested`, dan `AuthLogoutRequested`.
  - Mengelola layar `LoginScreen` dan `RegisterScreen` dengan validasi form interaktif.
- **`dashboard_project/`**:
  - Mengimplementasikan pola penomoran halaman tab yang canggih (Tab/Paging Pattern) melalui `DashboardProjectBloc`.
  - BLoC mengelola state 3 tab secara independen dalam satu state global (`DashboardProjectState` memuat 3 objek `DashboardProjectTabPagingState` untuk tab `closest`, `latest`, dan `popular`).
  - `DashboardScreen`: Menggunakan `NestedScrollView` dengan `SliverAppBar`, dilengkapi `LocationPickerTrigger` untuk mendeteksi perubahan koordinat lokasi GPS secara dinamis dan memperbarui data tab terdekat secara otomatis.
- **`main_tab/`**:
  - `MainTab`: Mengatur kontainer layar utama dengan navigasi bawah persisten menggunakan `persistent_bottom_nav_bar_v2`. Navigasi ini menampung 5 tab: Dashboard, My Project, Tombol Tengah Tambah Proyek (menggunakan trigger kustom tanpa layar tab), Chats, dan Profile.
- **`my_project/`**:
  - `MyProjectScreen`: Menampilkan proyek yang dimiliki pengguna atau proyek yang sedang diikuti, dengan navigasi tab dan status pagenasi.
- **`profil_project/`**:
  - `ProfilScreen`: Menampilkan profil lengkap pengguna, portofolio proyek, rating, dan riwayat pekerjaan. Dilengkapi tombol edit profil dan penyesuaian keahlian (skills).
- **`project_detail/`**:
  - `ProjectDetailScreen`: Layar detail proyek yang komprehensif. Menampilkan peta mini lokasi proyek, rincian deskripsi menggunakan format visual rich-text, daftar kuota partisipan, tagar proyek, serta tombol aksi lamar kerja atau hubungi pemilik proyek (chat) secara langsung.
- **`project_form/`**:
  - `ProjectFormScreen`: Form pembuatan atau penyuntingan proyek. Mengintegrasikan rich-text editor (`flutter_quill`) untuk input deskripsi, peta interaktif untuk menentukan titik kordinat proyek secara presisi, serta pemilihan kategori proyek secara drop-down.
- **`chat/`**:
  - `ChatListScreen`: Daftar riwayat obrolan aktif pengguna.
  - `ChatScreen`: Halaman percakapan dua arah secara real-time. Mengintegrasikan socket stream reaktif yang memperbarui daftar pesan secara instan saat menerima balasan dari WebSocket.
- **`search/`**:
  - Mengelola proses pencarian proyek dengan filter tingkat lanjut berdasarkan kategori, jarak lokasi, rating, status proyek, dan kriteria pengurutan terbaru/terpopuler.
  - `SearchInitialScreen` menampilkan histori pencarian lokal yang disimpan pada Shared Preferences, sementara `SearchResultScreen` menyajikan hasil pencarian interaktif lengkap dengan loading skeletonizer.

---

## 3. Pola Penulisan Kode & Konvensi

Demi menjaga keterbacaan dan konsistensi kode di seluruh tim, ikuti aturan dan pola berikut:

### 3.1. BLoC & State Management
- **Equatable:** Selalu turunan (extends) `Equatable` pada setiap kelas Event dan State untuk menghindari rendering ulang widget yang tidak perlu akibat perbedaan referensi objek yang sama nilainya.
- **Tab/Paging Pattern:** Untuk modul dengan daftar berhalaman (infinite scroll) yang kompleks dan terbagi dalam beberapa tab (seperti di `DashboardProjectBloc`), buat satu state penampung khusus untuk data pagenasi tab (`DashboardProjectTabPagingState`) yang mencatat daftar data, nomor halaman saat ini (`currentPage`), flag memuat halaman selanjutnya (`isFetchingMore`), flag memuat awal (`isFetchingInitial`), dan indikator akhir data (`hasReachedMax`). Di dalam state utama BLoC, simpan objek tab ini secara terpisah (misal: `closest`, `latest`, `popular`).
- **Concurrent Events:** Untuk mencegah request pagenasi beruntun (double-trigger) ketika pengguna scroll dengan cepat ke ujung bawah layar, gunakan transformer `droppable()` dari paket `bloc_concurrency` pada event `LoadMoreProjectsEvent` agar event yang masuk saat pemrosesan masih berjalan diabaikan.
- **Stream Processing:** Gunakan konstruksi `emit.forEach` jika BLoC perlu menangani aliran data terus-menerus (seperti update status lokasi GPS atau penerimaan pesan WebSocket secara berkelanjutan).

### 3.2. Penanganan Otorisasi & API
- **Token Management:** Seluruh urusan penambahan token `Authorization: Bearer <token>` dan refresh token dikelola secara terpusat di `ApiService`. Layer repositori tidak boleh mengurusi penyisipan header secara manual.
- **Form Data Re-creation:** Saat terjadi refresh token otomatis pada request yang mengirimkan file (seperti unggah gambar profil atau lampiran proyek), interceptor di `ApiService` akan secara otomatis menyalin ulang data `FormData` lama ke objek request baru agar request retry berhasil tanpa terjadi exception *Form data has been finalized*.

### 3.3. Dependency Injection (DI)
- Pendaftaran service global asinkron yang membutuhkan inisialisasi awal (seperti `StorageService` untuk Shared Preferences) didaftarkan menggunakan `registerSingletonAsync` dan diatur urutan dependensinya menggunakan argumen `dependsOn` (misalnya `ApiService` bergantung pada `StorageService` dan `ConnectivityService`).
- Inisialisasi awal ditahan pada `main.dart` dengan menunggu `getIt.allReady()`, sehingga ketika `MyApp` dipasang, seluruh instansi objek penting sudah siap digunakan.
- Repositori dan BLoC di-inject ke dalam widget tree menggunakan `MultiRepositoryProvider` dan `MultiBlocProvider` agar modul-modul di bawahnya dapat dengan mudah mengakses repositori melalui `context.read<T>()` tanpa harus memanggil GetIt langsung di dalam UI widget.

### 3.4. Naming Conventions (Aturan Penamaan)
- **Nama File:** Gunakan format `snake_case.dart` (contoh: `project_repository_impl.dart`, `dashboard_project_bloc.dart`).
- **Nama Kelas:** Gunakan format `PascalCase` (contoh: `ProjectRepositoryImpl`, `DashboardProjectBloc`).
- **File BLoC:** Harus selalu terbagi menjadi tiga file dengan akhiran penamaan yang seragam:
  - `<nama_fitur>_bloc.dart`
  - `<nama_fitur>_event.dart`
  - `<nama_fitur>_state.dart`
- **Entitas vs Model:** Selalu berikan akhiran kata `Entity` untuk kelas murni di layer domain (contoh: `UserEntity`) dan akhiran kata `Model` untuk kelas serialisasi JSON di layer data (contoh: `UserModel`).

### 3.5. UI Development & Aesthetics
- **Theme Matching:** Jangan pernah menuliskan warna hex secara langsung (hardcoded) pada kode widget. Gunakan properti warna dinamis yang disediakan oleh tema aktif saat ini, misalnya `Theme.of(context).colorScheme.primary` atau `Theme.of(context).colorScheme.secondary`.
- **Skeleton Shimmer:** Setiap pemuatan data awal dari API pada daftar atau halaman detail wajib dibungkus dengan widget `Skeletonizer` dan dilewatkan dengan data tiruan (seperti `ProjectEntity.dummyProject()`) agar transisi saat data selesai dimuat terlihat sangat mulus dan premium.
- **Dynamic Bottom Sheets:** Gunakan Wolt Modal Sheet untuk semua jenis bottom sheet interaktif yang membutuhkan formulir multi-halaman atau konten pembanding yang detail (seperti peninjauan rincian lokasi proyek).
- **Safe Area & Inset:** Selalu perhatikan *bottom inset* keyboard di halaman form (`resizeToAvoidBottomInset: true`) dan bungkus layar form dengan `SafeArea` agar elemen interaktif tidak terpotong oleh sistem notch atau bar navigasi sistem operasi.
