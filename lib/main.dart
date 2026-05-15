import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sejasa/core/di/app_providers.dart';
import 'package:sejasa/core/di/dependency_injection.dart';
import 'package:sejasa/modules/main_tab/bloc/main_tab_bloc.dart';
import 'package:sejasa/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await DependencyInjection.init();

  await getIt.allReady();

  runApp(
    MultiRepositoryProvider(
      providers: AppProviders.repositoryProviers,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => MainTabBloc()),
          ...AppProviders.blocProviders,
        ],
        child: const MyApp(),
      ),
    ),
  );
}
