import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/auth/controller/github_controller.dart';
import 'features/auth/controller/weather_controller.dart';
import 'theme/theme.dart';
import 'theme/theme_controller.dart';
import 'features/auth/controller/image_controller.dart';
import 'services/localization_controller.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => GithubController()),
        ChangeNotifierProvider(create: (_) => WeatherController()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => ImageController()),
        ChangeNotifierProvider(create: (_) => LocalizationController()),
      ],
      child: Consumer2<ThemeController, LocalizationController>(
        builder: (context, themeController, localizationController, _) {
          return MaterialApp(
            title: 'Flutter Auth App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            // Localization Configuration
            locale: localizationController.locale,
            supportedLocales: const [
              Locale('en'),
              Locale('hi'),
              Locale('fr'),
              Locale('zh'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            // Home Navigation
            home: Consumer<AuthController>(
              builder: (context, authController, _) {
                // If user is authenticated, show dashboard, otherwise show login
                return authController.isAuthenticated
                    ? const DashboardScreen()
                    : const LoginScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
