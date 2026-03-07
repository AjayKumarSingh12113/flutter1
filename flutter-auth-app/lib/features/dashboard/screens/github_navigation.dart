import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/controller/github_controller.dart';
import '../../auth/controller/auth_controller.dart';

class GithubNavigation extends StatefulWidget {
  const GithubNavigation({Key? key}) : super(key: key);

  @override
  State<GithubNavigation> createState() => _GithubNavigationState();
}

class _GithubNavigationState extends State<GithubNavigation> {
  @override
  void initState() {
    super.initState();
    debugPrint('🔶 [GithubNavigation] initState() called');
    Future.microtask(() {
      if (mounted) {
        debugPrint('🔶 [GithubNavigation] Calling getUser() from initState');
        context.read<GithubController>().getUser("AjayKumarSingh12113");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final githubController = Provider.of<GithubController>(context);
    final authController = Provider.of<AuthController>(context);

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<GithubController>().getUser("AjayKumarSingh12113");
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.7),
                ],
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.code_rounded,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(height: 12),
                const Text(
                  'GitHub Profile',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  authController.currentUser?.name ?? 'User',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // GitHub Profile Card
          Transform.translate(
            offset: const Offset(0, 20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: githubController.isLoading
                  ? _buildLoadingCard()
                  : githubController.user != null
                      ? _buildProfileCard(githubController)
                      : _buildErrorCard(),
            ),
          ),
          const SizedBox(height: 30),
        ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Builder(
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(48),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(GithubController controller) {
    final user = controller.user!;
    return Builder(
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Avatar with border
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 4,
                  ),
                ),
                child: CircleAvatar(
                  radius: 56,
                  backgroundImage: NetworkImage(user.avatarUrl),
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
              const SizedBox(height: 20),

              // Name
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Bio
              if (user.bio.isNotEmpty)
                Text(
                  user.bio,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 24),

              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatColumn(
                    'Followers',
                    user.followers.toString(),
                    Icons.people_rounded,
                  ),
                  Container(
                    height: 50,
                    width: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                  _buildStatColumn(
                    'Repos',
                    user.repos.toString(),
                    Icons.folder_rounded,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorCard() {
    return Builder(
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(48),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 56,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Unable to load GitHub profile',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatColumn(String label, String value, IconData icon) {
    return Builder(
      builder: (context) {
        return Column(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }
}
