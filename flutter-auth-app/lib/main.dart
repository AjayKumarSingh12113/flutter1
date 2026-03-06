import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/auth/controller/github_controller.dart';
import 'features/auth/controller/weather_controller.dart';

Future<void> main() async {
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
      ],
      child: MaterialApp(
        title: 'Flutter Auth App',
        theme: ThemeData(
          primaryColor: Colors.blue,
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Roboto',
        ),
        debugShowCheckedModeBanner: false,
        home: Consumer<AuthController>(
          builder: (context, authController, _) {
            // If user is authenticated, show dashboard, otherwise show login
            return authController.isAuthenticated
                ? const DashboardScreen()
                : const LoginScreen();
          },
        ),
      ),
    );
  }
}
