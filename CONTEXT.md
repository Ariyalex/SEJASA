# Project Context: Sejasa

Dokumen ini memberikan panduan mendalam mengenai arsitektur, teknologi, dan pola penulisan kode yang digunakan dalam proyek Sejasa.

## 1. Tech Stack & Dependencies Utama

Aplikasi ini dibangun menggunakan Flutter dengan fokus pada modularitas dan skalabilitas.

- **Framework:** Flutter (SDK ^3.10.0-290.4.beta)
- **State Management:** 
  - `flutter_bloc` (v9.1.1) dengan `bloc_concurrency` untuk manajemen side-effect.
  - `flutter_hooks` untuk manajemen state lokal widget yang lebih clean.
- **Routing:** `go_router` (v17.2.2) dengan struktur navigasi terpusat.
- **Networking & API:** `dio` (v5.9.2) dengan interceptor untuk logging dan error handling.
- **Dependency Injection:** `get_it` untuk Service Locator dan `RepositoryProvider` (bloc) untuk layer presentasi.
- **Real-time / Socket:** `web_socket_channel` untuk fitur chat dan update real-time.
- **Local Storage:** `shared_preferences` untuk data persistensi ringan.
- **UI & Helpers:**
  - `flex_color_scheme`: Manajemen tema aplikasi yang konsisten.
  - `skeletonizer`: Efek loading yang responsif.
  - `lucide_icons_flutter`: Library icon set.
  - `toastification`: Notifikasi in-app.
  - `flutter_map` & `geolocator`: Fitur berbasis lokasi.
  - `flutter_quill`: Rich text editor untuk deskripsi project.

## 2. Arsitektur Proyek (Deep-Dive)

Proyek ini mengadopsi **Clean Architecture** yang dimodifikasi untuk kebutuhan Flutter, dipadukan dengan **Feature-Driven Design**.

### 2.1. `lib/core/` (The Backbone)
Berisi fungsionalitas inti yang digunakan di seluruh aplikasi.
- **`config/`**: Konfigurasi global aplikasi (`AppConfig`).
- **`di/`**: Registrasi dependency (`DependencyInjection`) dan provider global (`AppProviders`).
- **`services/`**: Implementasi service mandiri:
  - `ApiService`: Wrapper Dio untuk komunikasi REST API.
  - `SocketService`: Manajemen koneksi WebSocket.
  - `StorageService`: Wrapper Local Storage.
  - `LocationService`: Abstraksi geolocator.
- **`routes/`**: Definisi `AppRouter` dan konstanta `RouteNamed`.
- **`theme/`**: Konfigurasi `AppTheme` menggunakan FlexColorScheme.
- **`utils/`**: Helper seperti `LogUtils` dan UI helper seperti `MySnackbar`.
- **`widgets/`**: Reusable components tingkat global (Button, TextField, ProjectItem).

### 2.2. `lib/domain/` (The Business Logic)
Layer yang paling murni, tidak bergantung pada framework luar.
- **`entities/`**: Objek data murni (`ProjectEntity`, `ChatEntity`, `UserEntity`).
- **`repositories/`**: Kontrak (Interface) untuk repository.
- **`providers/`**: Kontrak untuk data source.
- **`value_objects/`**: Definisi tipe data spesifik (Enums seperti `ProjectStatus`, `GenderType`).

### 2.3. `lib/data/` (The Implementation)
Implementasi dari layer domain.
- **`models/`**: Data Transfer Objects (DTO) dengan factory `fromJson` dan method `toJson`.
- **`payloads/`**: Objek untuk body request API (Create/Update payload).
- **`repositories/`**: Implementasi repository yang mengoordinasikan data dari providers.
- **`providers/`**: Implementasi source data:
  - `remote/`: Komunikasi dengan API server.
  - `mock/`: Data dummy untuk development/testing.

### 2.4. `lib/modules/` (The Features)
Struktur berbasis fitur. Setiap folder (misal: `auth`, `chat`, `dashboard_project`) berisi:
- **`bloc/`**: Manajemen state fitur tersebut.
- **`view/`**: Layar UI utama (Screen/Page).
- **`widgets/`**: Komponen UI yang hanya digunakan di fitur tersebut.

## 3. Pola Penulisan Kode & Konvensi

### 3.1. BLoC & State Management
- Gunakan `equatable` untuk setiap State dan Event.
- **Tab/Paging Pattern:** Untuk list yang kompleks, gunakan state yang menyimpan map atau list berdasarkan kategori/tab (lihat `DashboardProjectBloc`).
- Gunakan `emit.forEach` dari `bloc_concurrency` untuk menangani stream data secara efisien.

### 3.2. Reactive Repository
Repository sering kali menyediakan `Stream` (misal: `projectUpdateStream`) untuk memberitahu modul lain ketika terjadi perubahan data tanpa perlu refresh manual atau callback yang rumit.

### 3.3. Dependency Injection (DI)
- Service inti diinisialisasi secara asynchronous pada `main.dart` menggunakan `GetIt.instance.allReady()`.
- Repository di-inject ke widget tree menggunakan `MultiRepositoryProvider` agar mudah diakses oleh BLoC di layer bawah.

### 3.4. Naming Conventions
- **Files:** `snake_case.dart` (misal: `project_detail_screen.dart`).
- **Classes:** `PascalCase` (misal: `ProjectDetailScreen`).
- **BLoC Files:** `feature_name_bloc.dart`, `feature_name_event.dart`, `feature_name_state.dart`.
- **Entities vs Models:** Selalu gunakan suffix `Entity` untuk domain dan `Model` untuk data layer.

### 3.5. UI Development
- Prioritaskan penggunaan komponen dari `core/widgets` untuk menjaga konsistensi UI.
- Gunakan `Skeletonizer` untuk state loading pada list atau detail page.
- Gunakan `flex_color_scheme` (Theme.of(context).colorScheme) untuk penentuan warna, hindari hardcoding hex color di widget.
