import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/core/routes/route_named.dart';
import 'package:sejasa/core/widgets/my_text_field.dart';
import 'package:sejasa/modules/auth/view/register_screen.dart';
import 'package:sejasa/modules/auth/bloc/auth_bloc.dart';
import 'package:sejasa/modules/auth/bloc/auth_event.dart';
import 'package:sejasa/modules/auth/bloc/auth_state.dart';
import 'package:sejasa/core/utils/my_snackbar.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  /// Kembali ke dashboard. Pakai pop kalau bisa (mis. dibuka dari dashboard
  /// via pushNamed), kalau tidak bisa (mis. cold start langsung ke /login)
  /// fallback ke goNamed dashboard.
  void _backToDashboard(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(RouteNamed.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final isLoadingState = useState(false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          tooltip: 'Kembali',
          onPressed: () => _backToDashboard(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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

            if (state.status == AuthStatus.authenticated) {
              MySnackbar.success(
                title: "Login Berhasil",
                message: state.message ?? "Selamat datang kembali!",
              );
            } else if (state.status == AuthStatus.error) {
              MySnackbar.error(
                title: "Login Gagal",
                message: state.message ?? "Username atau password salah",
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
                  const SizedBox(height: 16),

                  // Logo placeholder — ganti dengan asset logo SEJASA jika sudah tersedia
                  Center(
                    child: Text(
                      'Logo',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 80,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  Center(
                    child: Text(
                      'Masuk Akun',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  MyTextField(
                    title: 'Email',
                    hint: 'email kamu...',
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

                  MyTextField(
                    title: 'Password',
                    hint: 'password kamu....',
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
                  const SizedBox(height: 16),

                  FilledButton(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
                        context.read<AuthBloc>().add(
                          AuthLoginRequested(
                            emailController.text.trim(),
                            passwordController.text,
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        // TODO: navigasi ke forgot password
                      },
                      child: Text(
                        'Lupa password?',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Tidak punya akun? ',
                          style: theme.textTheme.bodyMedium,
                        ),
                        GestureDetector(
                          onTap: () => _showAccountTypePicker(context),
                          child: Text(
                            'Daftar',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Menampilkan bottom sheet untuk memilih jenis akun
  /// (Perorangan / Organisasi) sebelum masuk ke register screen.
  void _showAccountTypePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: _AccountTypeSheet(
            onSelected: (type) {
              Navigator.of(sheetContext).pop();
              context.pushNamed(RouteNamed.register, extra: type);
            },
          ),
        );
      },
    );
  }
}

class _AccountTypeSheet extends HookWidget {
  const _AccountTypeSheet({required this.onSelected});

  final void Function(AccountType type) onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selected = useState<AccountType?>(null);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih jenis akun',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _AccountTypeTile(
            label: 'Perorangan',
            selected: selected.value == AccountType.personal,
            onTap: () {
              selected.value = AccountType.personal;
              onSelected(AccountType.personal);
            },
            color: colorScheme.primary,
          ),
          const SizedBox(height: 4),
          _AccountTypeTile(
            label: 'Organisasi',
            selected: selected.value == AccountType.organization,
            onTap: () {
              selected.value = AccountType.organization;
              onSelected(AccountType.organization);
            },
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _AccountTypeTile extends StatelessWidget {
  const _AccountTypeTile({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            // Radio-style indikator (dot bulat)
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
                color: selected ? color : Colors.transparent,
              ),
            ),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
