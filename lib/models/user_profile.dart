class UserProfile {
  final String id;
  final String? fullName;
  final String? email;
  final String? mobile;
  final String? username;
  final String? avatarUrl;

  UserProfile({
    required this.id,
    this.fullName,
    this.email,
    this.mobile,
    this.username,
    this.avatarUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(
        id: j['id'] as String,
        fullName: j['full_name'] as String?,
        email: j['email'] as String?,
        mobile: j['mobile'] as String?,
        username: j['username'] as String?,
        avatarUrl: j['avatar_url'] as String?,
      );
}
