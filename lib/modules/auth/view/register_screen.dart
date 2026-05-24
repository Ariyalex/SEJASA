import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:sejasa/core/routes/route_named.dart';
import 'package:sejasa/core/utils/my_snackbar.dart';
import 'package:sejasa/core/widgets/my_text_field.dart';
import 'package:sejasa/core/widgets/project_location_picker.dart';
import 'package:sejasa/data/payloads/register_payload.dart';
import 'package:sejasa/domain/value_objects/account_type.dart';
import 'package:sejasa/modules/auth/bloc/auth_bloc.dart';
import 'package:sejasa/modules/auth/bloc/auth_event.dart';
import 'package:sejasa/modules/auth/bloc/auth_state.dart';

/// Register screen untuk Perorangan dan Organisasi.
///
/// Perbedaan:
/// - Perorangan: field "Nama" + dropdown "gender"
/// - Organisasi: field "Nama Organisasi", tanpa gender
///
/// Sisa field (Email, Alamat + peta, Password, Konfirmasi Password) sama.
class RegisterScreen extends HookWidget {
  const RegisterScreen({super.key, this.accountType = AccountType.personal});

  final AccountType accountType;

  bool get _isOrganisasi => accountType == AccountType.organization;

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
    final isLoadingState = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isOrganisasi ? 'Register organisasi' : 'Register perorangan',
        ),
        surfaceTintColor: Colors.transparent,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.loading) {
            isLoadingState.value = true;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const WillPopScope(
                onWillPop: null, // disables back button while loading
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          } else {
            if (isLoadingState.value) {
              isLoadingState.value = false;
              Navigator.of(context, rootNavigator: true).pop();
            }

            if (state.status == AuthStatus.success) {
              MySnackbar.success(
                title: "Registrasi Berhasil",
                message: state.message ?? "Silakan masuk dengan akun Anda.",
              );
              // Kembali ke login jika bisa, kalau tidak go ke /login
              if (context.canPop()) {
                context.pop();
              } else {
                context.goNamed(RouteNamed.login);
              }
            } else if (state.status == AuthStatus.error) {
              MySnackbar.error(
                title: "Registrasi Gagal",
                message: state.message ?? "Terjadi kesalahan saat registrasi",
              );
            }
          }
        },
        child: SafeArea(
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
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return _isOrganisasi
                            ? 'Nama organisasi wajib diisi'
                            : 'Nama wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  MyTextField(
                    title: 'Email',
                    hint: 'Email aktif',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email wajib diisi';
                      }
                      final emailRegExp = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegExp.hasMatch(value.trim())) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  ProjectLocationPicker(
                    initialLocation: selectedLocation.value,
                    initialAddress: alamatController.text,
                    title: 'Lokasi Anda',
                    description:
                        'Ketuk peta untuk memilih lokasi Anda secara presisi.',
                    onLocationChanged: (LatLng location, String address) {
                      selectedLocation.value = location;
                      alamatController.text = address;
                    },
                  ),
                  const SizedBox(height: 4),
                  MyTextField(
                    hint: 'Pilih lokasi untuk mengisi alamat...',
                    controller: alamatController,
                    readOnly: true,
                    maxLines: 1,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Alamat wajib diisi';
                      }
                      return null;
                    },
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
                          validator: (value) {
                            if (!_isOrganisasi && value == null) {
                              return 'Gender wajib diisi';
                            }
                            return null;
                          },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password wajib diisi';
                      }
                      if (value.length < 6) {
                        return 'Password minimal 6 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  MyTextField(
                    title: 'Konfirmasi password',
                    hint: 'isi ulang password',
                    controller: konfirmasiController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Konfirmasi password wajib diisi';
                      }
                      if (value != passwordController.text) {
                        return 'Konfirmasi password tidak cocok';
                      }
                      return null;
                    },
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
                      if (formKey.currentState?.validate() == true) {
                        if (selectedLocation.value == null) {
                          MySnackbar.error(
                            title: "Lokasi Belum Dipilih",
                            message:
                                "Silakan pilih lokasi Anda di peta terlebih dahulu.",
                          );
                          return;
                        }

                        final payload = RegisterPayload(
                          name: namaController.text.trim(),
                          email: emailController.text.trim(),
                          password1: passwordController.text,
                          password2: konfirmasiController.text,
                          gender: _isOrganisasi ? '' : (gender.value ?? ''),
                          accountType: accountType.name,
                          latitude: selectedLocation.value!.latitude,
                          longitude: selectedLocation.value!.longitude,
                        );

                        context.read<AuthBloc>().add(
                          AuthRegisterRequested(payload),
                        );
                      }
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
      ),
    );
  }
}
