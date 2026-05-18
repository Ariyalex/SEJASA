import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sejasa/core/di/dependency_injection.dart';
import 'package:sejasa/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await DependencyInjection.init();

  runApp(const MyApp());
}
