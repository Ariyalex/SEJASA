import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:sejasa/core/widgets/my_text_field.dart';
import 'package:sejasa/data/payloads/register_payload.dart';
import 'package:sejasa/modules/auth/bloc/auth_bloc.dart';
import 'package:sejasa/modules/auth/bloc/auth_event.dart';
import 'package:sejasa/modules/auth/bloc/auth_state.dart';

class RegisterScreen extends HookWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final pass1Controller = useTextEditingController();
    final pass2Controller = useTextEditingController();
    final accountTypeController = useTextEditingController(text: 'personal');
    final genderController = useTextEditingController();
    final latController = useTextEditingController(text: '0.0');
    final lngController = useTextEditingController(text: '0.0');

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                MyTextField(
                  controller: nameController,
                  title: "Nama",
                  hint: "Masukkan nama lengkap",
                  validator: (value) => value == null || value.isEmpty
                      ? "Nama tidak boleh kosong"
                      : null,
                ),
                const SizedBox(height: 16),
                MyTextField(
                  controller: emailController,
                  title: "Email",
                  hint: "Masukkan email",
                  validator: (value) => value == null || value.isEmpty
                      ? "Email tidak boleh kosong"
                      : null,
                ),
                const SizedBox(height: 16),
                MyTextField(
                  controller: pass1Controller,
                  title: "Password",
                  hint: "Masukkan password",
                  obscureText: true,
                  validator: (value) => value == null || value.isEmpty
                      ? "Password tidak boleh kosong"
                      : null,
                ),
                const SizedBox(height: 16),
                MyTextField(
                  controller: pass2Controller,
                  title: "Konfirmasi Password",
                  hint: "Masukkan kembali password",
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Konfirmasi password tidak boleh kosong";
                    if (value != pass1Controller.text)
                      return "Password tidak cocok";
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                MyTextField(
                  controller: accountTypeController,
                  title: "Tipe Akun",
                  hint: "personal / company",
                  validator: (value) => value == null || value.isEmpty
                      ? "Tipe akun tidak boleh kosong"
                      : null,
                ),
                const SizedBox(height: 16),
                MyTextField(
                  controller: genderController,
                  title: "Jenis Kelamin (Optional)",
                  hint: "male / female",
                  validator: (value) => value == null || value.isEmpty
                      ? "gender tidak boleh kosong"
                      : null,
                ),
                const SizedBox(height: 16),
                MyTextField(
                  controller: latController,
                  title: "Latitude",
                  hint: "0.0",
                ),
                const SizedBox(height: 16),
                MyTextField(
                  controller: lngController,
                  title: "Longitude",
                  hint: "0.0",
                ),
                const SizedBox(height: 24),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const CircularProgressIndicator();
                    }
                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) {
                                final payload = RegisterPayload(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password1: pass1Controller.text,
                                  password2: pass2Controller.text,
                                  accountType: accountTypeController.text,
                                  gender: genderController.text,
                                  latitude:
                                      double.tryParse(latController.text) ??
                                      0.0,
                                  longitude:
                                      double.tryParse(lngController.text) ??
                                      0.0,
                                );
                                context.read<AuthBloc>().add(
                                  AuthRegisterRequested(payload),
                                );
                              }
                            },
                            child: const Text("Register"),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: const Text("Sudah punya akun? Masuk"),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
