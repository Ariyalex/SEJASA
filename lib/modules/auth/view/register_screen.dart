import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/core/routes/route_named.dart';
import 'package:sejasa/core/widgets/my_text_field.dart';

/// Jenis akun yang dipilih user saat register.
/// Dipakai juga sebagai parameter ke [RegisterScreen].
enum AccountType { perorangan, organisasi }

/// Register screen untuk Perorangan dan Organisasi.
///
/// Perbedaan:
/// - Perorangan: field "Nama" + dropdown "gender"
/// - Organisasi: field "Nama Organisasi", tanpa gender
///
/// Sisa field (Email, Alamat + peta, Password, Konfirmasi Password) sama.
class RegisterScreen extends HookWidget {
  const RegisterScreen({
    super.key,
    this.accountType = AccountType.perorangan,
  });

  final AccountType accountType;

  bool get _isOrganisasi => accountType == AccountType.organisasi;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Controllers
    final namaController = useTextEditingController();
    final emailController = useTextEditingController();
    final alamatController = useTextEditingController();
    final passwordController = useTextEditingController();
    final konfirmasiController = useTextEditingController();

    // State
    final gender = useState<String?>(null); // hanya dipakai jika perorangan
    final selectedLocation = useState<LatLng?>(null);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final mapController = useMemoized(() => MapController());
    useEffect(() => mapController.dispose, [mapController]);

    // Default kamera peta: Yogyakarta (sesuaikan jika perlu)
    const defaultCenter = LatLng(-7.7956, 110.3695);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isOrganisasi ? 'Register organisasi' : 'Register perorangan',
        ),
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),

                // Logo placeholder — ganti dengan asset logo SEJASA jika ada
                Center(
                  child: Text(
                    'Logo',
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 72,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Center(
                  child: Text(
                    'Daftar Akun',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                MyTextField(
                  title: _isOrganisasi ? 'Nama Organisasi' : 'Nama',
                  hint: _isOrganisasi ? 'nama organisasi...' : 'nama lengkap',
                  controller: namaController,
                ),
                const SizedBox(height: 12),

                MyTextField(
                  title: 'Email',
                  hint: 'Email aktif',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),

                // Alamat + tombol pilih lokasi (sesuai mockup)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: MyTextField(
                        title: 'Alamat',
                        hint: 'alamat lengkap',
                        controller: alamatController,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: colorScheme.outline),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(LucideIcons.mapPin),
                          tooltip: 'Pilih lokasi di peta',
                          onPressed: () {
                            // Scroll fokus ke peta (peta sudah tampil di bawah)
                            // TODO: optional — bisa juga buka full-screen map picker
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Peta lokasi (sesuai mockup)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lokasi Anda',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.locateFixed),
                      tooltip: 'Gunakan lokasi saat ini',
                      onPressed: () {
                        // TODO: integrasi geolocator untuk get current position,
                        // lalu mapController.move(latLng, 16) + selectedLocation.value = latLng;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 220,
                    child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        initialCenter: defaultCenter,
                        initialZoom: 14,
                        onTap: (tapPosition, latLng) {
                          selectedLocation.value = latLng;
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.sejasa.app',
                        ),
                        if (selectedLocation.value != null)
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: selectedLocation.value!,
                                width: 36,
                                height: 36,
                                child: Icon(
                                  Icons.location_on,
                                  color: colorScheme.primary,
                                  size: 36,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ketuk peta untuk memilih lokasi Anda secara presisi.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),

                // Gender — hanya muncul untuk perorangan
                if (!_isOrganisasi) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gender',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<String>(
                        initialValue: gender.value,
                        decoration: InputDecoration(
                          hintText: 'gender',
                          filled: true,
                          fillColor: const Color(0xFFEEEEEE),
                          hintStyle: TextStyle(color: theme.disabledColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'male',
                            child: Text('Laki-laki'),
                          ),
                          DropdownMenuItem(
                            value: 'female',
                            child: Text('Perempuan'),
                          ),
                        ],
                        onChanged: (value) => gender.value = value,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                MyTextField(
                  title: 'Password',
                  hint: 'password rahasia',
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 12),

                MyTextField(
                  title: 'Konfirmasi password',
                  hint: 'isi ulang password',
                  controller: konfirmasiController,
                  obscureText: true,
                ),
                const SizedBox(height: 20),

                FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // TODO: panggil auth bloc untuk register
                    // sertakan accountType, dan jika perorangan: gender.value
                    // serta selectedLocation.value untuk koordinat alamat
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sudah punya akun? ',
                        style: theme.textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Kembali ke login: pop jika bisa, kalau tidak go ke /login
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.goNamed(RouteNamed.login);
                          }
                        },
                        child: Text(
                          'login',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
