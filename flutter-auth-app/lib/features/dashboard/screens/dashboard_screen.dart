import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/screens/login_screen.dart';
import 'github_navigation.dart';
import 'weather_navigation.dart';
import 'settings_navigation.dart';
import 'image_feed_screen.dart';
import '../../../features/auth/controller/github_controller.dart';
import '../../../features/auth/controller/weather_controller.dart';
import '../../../features/auth/controller/image_controller.dart';
import '../../../l10n/app_localizations_extension.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() => _loadInitialData());
  }

  Future<void> _loadInitialData() async {
    final github = context.read<GithubController>();
    final weather = context.read<WeatherController>();
    final images = context.read<ImageController>();

    /// 1️⃣ First load GitHub
    await github.getUser("AjayKumarSingh12113");

    /// 2️⃣ Wait 1 second
    await Future.delayed(const Duration(seconds: 1));

    /// 3️⃣ Load remaining APIs
    weather.getWeather('Delhi');
    images.loadImages();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.dashboard,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  authController.currentUser?.name ?? 'User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.logout_rounded, color: Colors.white),
              onPressed: () {
                _showLogoutDialog(context, authController);
              },
              tooltip: 'Logout',
            ),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: Consumer(
        builder: (context, _, __) {
          final l10n = context.l10n;
          return BottomNavigationBar(
            currentIndex: _selectedIndex,
            backgroundColor: Theme.of(context).cardColor,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Theme.of(context).disabledColor.withOpacity(0.5),
            type: BottomNavigationBarType.fixed,
            elevation: 8,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.code_rounded),
                activeIcon: const Icon(Icons.code_rounded),
                label: l10n.gitHubProfile,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.cloud_rounded),
                activeIcon: const Icon(Icons.cloud_rounded),
                label: l10n.weather,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.image_rounded),
                activeIcon: const Icon(Icons.image_rounded),
                label: l10n.imageFeed,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings_rounded),
                activeIcon: const Icon(Icons.settings_rounded),
                label: l10n.settings,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const GithubNavigation();
      case 1:
        return const WeatherNavigation();

      case 2:
        return const ImageFeedScreen();
      case 3:
        return const SettingsNavigation();
      default:
        return const GithubNavigation();
    }
  }

  void _showLogoutDialog(BuildContext context, AuthController authController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                authController.logout();
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
