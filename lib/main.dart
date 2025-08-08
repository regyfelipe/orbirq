import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:orbirq/core/network/network_info_export.dart';
import 'features/question/injection_container.dart' as question_injection;

import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/services/auth_service.dart';
import 'core/services/api_service.dart';
import 'features/performance/performance_injection.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  // Configura o GetIt
  await setupDependencies(prefs);
  
  runApp(
    MultiProvider(
      providers: [
        // Prover o SharedPreferences
        Provider<SharedPreferences>.value(value: prefs),
        
        // Prover o ApiService
        Provider<ApiService>(
          create: (context) => ApiService(prefs: prefs),
        ),
        
        // Prover o AuthService
        ChangeNotifierProvider<AuthService>(
          create: (context) => AuthService(
            apiService: context.read<ApiService>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> setupDependencies(SharedPreferences prefs) async {
  // Register SharedPreferences if not already registered
  if (!getIt.isRegistered<SharedPreferences>()) {
    getIt.registerLazySingleton<SharedPreferences>(() => prefs);
  }
  
  // Register HTTP client if not already registered
  if (!getIt.isRegistered<http.Client>()) {
    getIt.registerLazySingleton<http.Client>(() => http.Client());
  }
  
  // Register Connectivity if not already registered
  if (!getIt.isRegistered<Connectivity>()) {
    getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  }
  
  // Register NetworkInfo if not already registered
  if (!getIt.isRegistered<NetworkInfo>()) {
    getIt.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectivity: getIt()),
    );
  }
  
  // Register ApiService if not already registered
  if (!getIt.isRegistered<ApiService>()) {
    getIt.registerLazySingleton<ApiService>(
      () => ApiService(prefs: prefs),
    );
  }
  
  // Register AuthService if not already registered
  if (!getIt.isRegistered<AuthService>()) {
    getIt.registerLazySingleton<AuthService>(
      () => AuthService(apiService: getIt()),
    );
  }
  
  // Initialize performance feature
  initPerformanceFeature();
  
  // Initialize question feature
  await question_injection.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.getRoutes(),
    );
  }
}
