class Asset {
  final String id;
  final String code;
  final String issuerWallet;
  final bool authorizationRequired;
  final bool authorizationRevocable;
  final bool clawbackEnabled;
  final bool authorizationImmutable;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String balance;

  Asset({
    required this.id,
    required this.code,
    required this.issuerWallet,
    required this.authorizationRequired,
    required this.authorizationRevocable,
    required this.clawbackEnabled,
    required this.authorizationImmutable,
    required this.createdAt,
    required this.updatedAt,
    required this.balance,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'],
      code: json['code'],
      issuerWallet: json['issuerWallet'],
      authorizationRequired: json['authorizationRequired'],
      authorizationRevocable: json['authorizationRevocable'],
      clawbackEnabled: json['clawbackEnabled'],
      authorizationImmutable: json['authorizationImmutable'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      balance: json['balance'] ?? '0.0000000',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'issuerWallet': issuerWallet,
      'authorizationRequired': authorizationRequired,
      'authorizationRevocable': authorizationRevocable,
      'clawbackEnabled': clawbackEnabled,
      'authorizationImmutable': authorizationImmutable,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'balance': balance,
    };
  }
} 