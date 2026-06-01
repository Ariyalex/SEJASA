import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sejasa/core/di/app_providers.dart';
import 'package:sejasa/core/di/dependency_injection.dart';
import 'package:sejasa/core/routes/app_router.dart';
import 'package:sejasa/core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sejasa/modules/splash/view/splash_screen.dart';
import 'package:toastification/toastification.dart';

class MyApp extends HookWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isReady = useState(false);

    useEffect(() {
      getIt.allReady().then((_) {
        isReady.value = true;
      });
      return null;
    }, []);

    if (!isReady.value) {
      return MaterialApp(
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(message: "Menyiapkan sistem..."),
      );
    }

    return MultiRepositoryProvider(
      providers: AppProviders.repositoryProviders,
      child: MultiBlocProvider(
        providers: AppProviders.blocProviders,
        child: ToastificationWrapper(
          child: ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp.router(
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: ThemeMode.light,
                debugShowCheckedModeBanner: false,
                routerConfig: AppRouter.router,
                builder: (context, child) {
                  return child!;
                },
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  FlutterQuillLocalizations.delegate,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
