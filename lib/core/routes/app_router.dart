import 'package:go_router/go_router.dart';
import 'package:sejasa/core/routes/route_named.dart';
import 'package:sejasa/modules/main_tab/view/main_tab.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: RouteNamed.dashboard,
        name: RouteNamed.dashboard,
        builder: (context, state) => MainTab(),
      ),
    ],
  );
}
