class Authorization {
  final String accessToken;
  final String? refreshToken;

  const Authorization({
    required this.accessToken,
    this.refreshToken,
  });

  factory Authorization.fromJson(Map<String, dynamic> map) {
    return Authorization(
      accessToken: map['access_token'] ?? (map['token'] ?? ''),
      refreshToken: map['refresh_token'],
    );
  }
}
