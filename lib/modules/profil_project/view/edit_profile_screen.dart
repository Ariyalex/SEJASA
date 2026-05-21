import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/core/config/app_config.dart';
import 'package:sejasa/core/di/dependency_injection.dart';
import 'package:sejasa/core/services/location_service.dart';
import 'package:sejasa/core/utils/my_snackbar.dart';
import 'package:sejasa/core/widgets/global_location_picker_sheet.dart';
import 'package:sejasa/core/widgets/my_text_field.dart';
import 'package:sejasa/data/payloads/profile_update_payload.dart';
import 'package:sejasa/domain/repositories/file_repository.dart';
import 'package:sejasa/domain/providers/remote_user_provider.dart';
import 'package:sejasa/domain/value_objects/gender_type.dart';
import 'package:sejasa/modules/auth/bloc/auth_bloc.dart';
import 'package:sejasa/modules/auth/bloc/auth_event.dart';

class EditProfileScreen extends HookWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Ambil data user saat ini dari AuthBloc
    final authState = context.watch<AuthBloc>().state;
    final user = authState.user;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Services & Controllers
    final locationService = useMemoized(() => getIt<LocationService>());
    final fileRepository = useMemoized(() => getIt<FileRepository>());
    final userProvider = useMemoized(() => getIt<RemoteUserProvider>());

    final namaController = useTextEditingController(text: user.name);
    final emailController = useTextEditingController(text: user.email);
    final teleponController = useTextEditingController(
      text: user.contact ?? '',
    );
    final bioController = useTextEditingController(
      text: user.description ?? '',
    );
    final alamatController = useTextEditingController(text: user.address ?? '');

    // State
    final gender = useState<GenderType>(user.gender);
    final selectedLocation = useState<LatLng>(
      LatLng(
        user.latitude != 0.0 ? user.latitude : -7.7956,
        user.longitude != 0.0 ? user.longitude : 110.3695,
      ),
    );
    final profilePicturePath = useState<String?>(user.profilePicture);

    final formKey = useMemoized(() => GlobalKey<FormState>());
    final isSaving = useState(false);
    final isImageUploading = useState(false);
    final isMapLoading = useState(false);

    final mapController = useMemoized(() => MapController());
    useEffect(() => mapController.dispose, [mapController]);

    // Sinkronisasi inisialisasi peta jika data user dimuat
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (user.latitude != 0.0 && user.longitude != 0.0) {
          mapController.move(LatLng(user.latitude, user.longitude), 15.0);
        }
      });
      return null;
    }, [user.id]);

    // Fungsi upload gambar profil
    Future<void> _pickAndUploadImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (pickedFile == null) return;

      try {
        isImageUploading.value = true;
        final file = File(pickedFile.path);
        // Unggah gambar profil via FileRepository
        final uploadedUrl = await fileRepository.uploadImage(file);

        // Simpan path relatif/URL yang dikembalikan
        profilePicturePath.value = uploadedUrl;

        MySnackbar.success(
          title: "Sukses",
          message: "Foto profil berhasil diunggah",
        );
      } catch (e) {
        MySnackbar.error(
          title: "Gagal Mengunggah",
          message: "Terjadi kesalahan saat mengunggah foto profil.",
        );
      } finally {
        isImageUploading.value = false;
      }
    }

    // Fungsi submit form
    Future<void> submitForm() async {
      if (!(formKey.currentState?.validate() ?? false)) return;

      try {
        isSaving.value = true;

        final payload = UserUpdatePayload(
          name: namaController.text.trim(),
          email: emailController.text.trim(),
          contact: teleponController.text.trim(),
          description: bioController.text.trim(),
          gender: gender.value.jsonValue,
          detailAddress: alamatController.text.trim(),
          latitude: selectedLocation.value.latitude,
          longitude: selectedLocation.value.longitude,
          imagePath: profilePicturePath.value,
        );

        final updatedUser = await userProvider.updateMyProfile(payload);

        if (context.mounted) {
          // Sinkronisasi user baru ke AuthBloc
          context.read<AuthBloc>().add(AuthUserUpdated(updatedUser));

          MySnackbar.success(
            title: "Pembaruan Berhasil",
            message: "Profil Anda telah sukses diperbarui.",
          );
          context.pop();
        }
      } catch (e) {
        MySnackbar.error(
          title: "Gagal Memperbarui",
          message: e.toString().replaceAll("Exception:", "").trim(),
        );
      } finally {
        isSaving.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profil",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        surfaceTintColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Upload Foto Profil
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.primary.withOpacity(0.2),
                              width: 3,
                            ),
                          ),
                          child: ClipOval(
                            child: isImageUploading.value
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : (profilePicturePath.value != null
                                      ? Image.network(
                                          profilePicturePath.value!.startsWith(
                                                "http",
                                              )
                                              ? profilePicturePath.value!
                                              : AppConfig.baseUrl +
                                                    profilePicturePath.value!,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                                    Icons.person,
                                                    size: 60,
                                                    color: Colors.grey,
                                                  ),
                                        )
                                      : const Icon(
                                          Icons.person,
                                          size: 60,
                                          color: Colors.grey,
                                        )),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: isImageUploading.value
                                ? null
                                : _pickAndUploadImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                LucideIcons.camera,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2. Field Nama Lengkap
                  MyTextField(
                    title: "Nama Lengkap",
                    hint: "Masukkan nama lengkap Anda...",
                    controller: namaController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Nama wajib diisi";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 3. Field Email
                  MyTextField(
                    title: "Email",
                    hint: "Masukkan email aktif...",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Email wajib diisi";
                      }
                      final emailRegExp = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegExp.hasMatch(value.trim())) {
                        return "Format email tidak valid";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 4. Field Telepon / Kontak
                  MyTextField(
                    title: "Nomor Telepon",
                    hint: "Masukkan nomor telepon aktif...",
                    controller: teleponController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Nomor telepon wajib diisi";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 5. Gender Dropdown
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Gender",
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<GenderType>(
                        value: gender.value,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFEEEEEE),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        items: GenderType.values.map((type) {
                          return DropdownMenuItem<GenderType>(
                            value: type,
                            child: Row(
                              children: [
                                Icon(
                                  type.icon,
                                  size: 20,
                                  color: type == GenderType.male
                                      ? Colors.blue
                                      : Colors.pink,
                                ),
                                const SizedBox(width: 8),
                                Text(type.display),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            gender.value = val;
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 6. Field Deskripsi / Bio
                  MyTextField(
                    title: "Bio / Deskripsi",
                    hint:
                        "Ceritakan singkat tentang diri Anda atau pengalaman...",
                    controller: bioController,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),

                  // 7. Alamat + Peta Penentuan Lokasi
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: MyTextField(
                          title: "Alamat Lengkap",
                          hint:
                              "Masukkan alamat lengkap tempat tinggal Anda...",
                          controller: alamatController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Alamat wajib diisi";
                            }
                            return null;
                          },
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
                            tooltip: "Pilih lokasi di peta",
                            onPressed: () {
                              showGlobalLocationPicker(
                                context: context,
                                initialLocation: selectedLocation.value,
                                initialAddress: alamatController.text,
                                onLocationSelected: (location, address) {
                                  selectedLocation.value = location;
                                  alamatController.text = address;
                                  mapController.move(location, 16.0);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Posisikan Lokasi Anda",
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isMapLoading.value)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else
                        IconButton(
                          icon: const Icon(LucideIcons.locateFixed),
                          tooltip: "Gunakan lokasi GPS saat ini",
                          onPressed: () async {
                            try {
                              isMapLoading.value = true;
                              final pos = await locationService
                                  .getCurrentLocation(context);
                              if (context.mounted && pos != null) {
                                final loc = LatLng(pos.latitude, pos.longitude);
                                mapController.move(loc, 15.0);
                                selectedLocation.value = loc;
                                final address = await locationService
                                    .getAddressFromLatLng(loc);
                                if (context.mounted) {
                                  alamatController.text = address;
                                }
                              }
                            } catch (e) {
                              MySnackbar.error(
                                title: "GPS Error",
                                message:
                                    "Tidak dapat mengakses lokasi perangkat saat ini.",
                              );
                            } finally {
                              isMapLoading.value = false;
                            }
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
                          initialCenter: selectedLocation.value,
                          initialZoom: 14,
                          onTap: (tapPosition, latLng) async {
                            selectedLocation.value = latLng;
                            try {
                              isMapLoading.value = true;
                              final address = await locationService
                                  .getAddressFromLatLng(latLng);
                              if (context.mounted) {
                                alamatController.text = address;
                              }
                            } catch (e) {
                              // Abaikan geocoding error, tetap biarkan koordinat bergeser
                            } finally {
                              isMapLoading.value = false;
                            }
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                            userAgentPackageName: "com.sejasa.app",
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: selectedLocation.value,
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
                    "Ketuk peta untuk menentukan koordinat presisi.",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 8. Tombol Simpan
                  ElevatedButton(
                    onPressed: isSaving.value || isImageUploading.value
                        ? null
                        : submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: isSaving.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Text(
                            "Simpan Perubahan",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          if (isSaving.value)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
