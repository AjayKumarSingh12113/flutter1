class GithubUser {
  final String name;
  final String avatarUrl;
  final String bio;
  final int followers;
  final int repos;

  GithubUser({
    required this.name,
    required this.avatarUrl,
    required this.bio,
    required this.followers,
    required this.repos,
  });

  factory GithubUser.fromJson(Map<String, dynamic> json) {
    return GithubUser(
      name: json['name'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      bio: json['bio'] ?? '',
      followers: json['followers'] ?? 0,
      repos: json['public_repos'] ?? 0,
    );
  }
}