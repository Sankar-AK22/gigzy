import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'services/auth_service.dart';
import 'services/api_service.dart';
import 'providers/app_provider.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Load persisted settings before app starts
  final appProvider = AppProvider();
  await appProvider.loadSettings();

  runApp(GigShieldApp(appProvider: appProvider));
}

class GigShieldApp extends StatelessWidget {
  final AppProvider appProvider;

  const GigShieldApp({super.key, required this.appProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appProvider),
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => ApiService()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            title: 'GigShield',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: provider.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
