import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:sejasa/core/routes/route_named.dart';
import 'package:sejasa/core/widgets/my_text_field.dart';
import 'package:sejasa/modules/auth/bloc/auth_bloc.dart';
import 'package:sejasa/modules/auth/bloc/auth_event.dart';
import 'package:sejasa/modules/auth/bloc/auth_state.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mailController = useTextEditingController();
    final passController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? "Terjadi kesalahan"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  MyTextField(
                    controller: mailController,
                    title: "Email",
                    hint: "masukkan email",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  MyTextField(
                    controller: passController,
                    title: "Password",
                    hint: "masukkan password",
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state.status == AuthStatus.loading) {
                        return const CircularProgressIndicator();
                      }
                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () {
                                if (formKey.currentState?.validate() ?? false) {
                                  context.read<AuthBloc>().add(
                                    AuthLoginRequested(
                                      mailController.text,
                                      passController.text,
                                    ),
                                  );
                                }
                              },
                              child: const Text("Login"),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              context.pushNamed(RouteNamed.register);
                            },
                            child: const Text("Belum punya akun? Daftar"),
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
      ),
    );
  }
}
