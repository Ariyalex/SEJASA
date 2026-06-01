import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:sejasa/core/routes/route_named.dart';
import 'package:sejasa/core/services/connectivity_service.dart';
import 'package:sejasa/modules/auth/bloc/auth_bloc.dart';
import 'package:sejasa/modules/auth/bloc/auth_state.dart';

class SplashScreen extends HookWidget {
  final String? message;
  const SplashScreen({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final statusMessage = useState(message ?? "Menyiapkan sistem...");

    useEffect(() {
      // Jika dipanggil sebagai rute (message == null), jalankan alur inisialisasi fase 2
      if (message == null) {
        _startInitialization(context, statusMessage);
      }
      return null;
    }, []);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: 100),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(statusMessage.value),
          ],
        ),
      ),
    );
  }

  Future<void> _startInitialization(
    BuildContext context,
    ValueNotifier<String> statusMessage,
  ) async {
    // 1. Connectivity Check
    statusMessage.value = "Memeriksa koneksi...";
    final connectivity = context.read<ConnectivityService>();
    if (!connectivity.isConnected) {
      // Tunggu sebentar jika tidak ada koneksi, atau bisa ditambahkan retry logic
      await Future.delayed(const Duration(seconds: 1));
    }

    // 2. Auth Check
    statusMessage.value = "Memeriksa autentikasi...";
    final authBloc = context.read<AuthBloc>();

    // Tunggu jika AuthBloc masih dalam state awal/loading
    if (authBloc.state.status == AuthStatus.initial ||
        authBloc.state.status == AuthStatus.loading) {
      try {
        await for (final state in authBloc.stream) {
          if (state.status == AuthStatus.authenticated ||
              state.status == AuthStatus.unauthenticated) {
            break;
          }
        }
      } catch (_) {
        // Handle error jika perlu
      }
    }

    // 3. Routing
    if (context.mounted) {
      final state = authBloc.state;
      if (state.user != null) {
        context.goNamed(RouteNamed.mainTab);
      } else {
        context.go('/guest');
      }
    }
  }
}
