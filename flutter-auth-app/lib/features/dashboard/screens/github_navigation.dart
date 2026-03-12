import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/controller/github_controller.dart';
import '../../auth/controller/auth_controller.dart';
import '../../../l10n/app_localizations_extension.dart';

class GithubNavigation extends StatefulWidget {
  const GithubNavigation({Key? key}) : super(key: key);

  @override
  State<GithubNavigation> createState() => _GithubNavigationState();
}

class _GithubNavigationState extends State<GithubNavigation> {
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    debugPrint('🔶 [GithubNavigation] initState() called');
    Future.microtask(() {
      if (mounted) {
        debugPrint('🔶 [GithubNavigation] Calling getUser() with default username: AjayKumarSingh12113');
        context.read<GithubController>().getUser("AjayKumarSingh12113");
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final githubController = Provider.of<GithubController>(context);
    final authController = Provider.of<AuthController>(context);

    return RefreshIndicator(
      onRefresh: () async {
        final currentUsername = githubController.user?.name ?? "AjayKumarSingh12113";
        await context.read<GithubController>().getUser(currentUsername);
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

          // Username Search Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: context.l10n.enterGithubUsername,
                      prefixIcon: const Icon(Icons.code_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (value) {
                      _searchUser();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _searchUser,
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
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
                  : githubController.errorMessage != null
                      ? _buildErrorCard(githubController.errorMessage!)
                      : githubController.user != null
                          ? _buildProfileCard(githubController)
                          : const SizedBox.shrink(),
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

  Widget _buildErrorCard(String errorMessage) {
    return Builder(
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            border: Border.all(
              color: Colors.red.withOpacity(0.3),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'Error',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade400,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                errorMessage,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _usernameController.clear();
                    context.read<GithubController>().getUser('AjayKumarSingh12113');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Load Default User',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _searchUser() {
    final username = _usernameController.text.trim();
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a GitHub username'),
          backgroundColor: Colors.orange.shade400,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    debugPrint('🔵 [GithubNavigation] Searching for user: @$username');
    context.read<GithubController>().getUser(username);
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
