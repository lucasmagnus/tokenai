String formatWallet(String wallet) {
  return '${wallet.substring(0, 4)}...${wallet.substring(40, 44)}';
}

String formatBalance(String balance) {
  final parsed = double.tryParse(balance) ?? 0.0;
  final formatted = parsed.toStringAsFixed(7);
  return double.parse(formatted).toString();
}
