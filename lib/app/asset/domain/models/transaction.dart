class Transaction {
  final String id;
  final String type;
  final String createdAt;
  final String account;
  final String? amount;
  final String? assetCode;
  final String? assetIssuer;
  final bool isDebit;

  Transaction({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.account,
    this.amount,
    this.assetCode,
    this.assetIssuer,
    this.isDebit = false,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: json['type'],
      createdAt: json['createdAt'],
      account: json['account'],
      amount: json['amount'],
      assetCode: json['assetCode'],
      assetIssuer: json['assetIssuer'],
      isDebit: json['isDebit'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'createdAt': createdAt,
      'account': account,
      'amount': amount,
      'assetCode': assetCode,
      'assetIssuer': assetIssuer,
      'isDebit': isDebit,
    };
  }
} 