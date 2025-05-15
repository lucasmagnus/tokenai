import 'dart:convert';

class Contact {
  final String name;
  final String wallet;

  Contact({required this.name, required this.wallet});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'] as String,
      wallet: json['wallet'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'wallet': wallet,
    };
  }

  @override
  String toString() {
    return 'Contact(name: $name, wallet: $wallet)';
  }

  Contact copyWith({
    String? name,
    String? wallet,
  }) {
    return Contact(
      name: name ?? this.name,
      wallet: wallet ?? this.wallet,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Contact && other.name == name && other.wallet == wallet;
  }

  @override
  int get hashCode => name.hashCode ^ wallet.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'wallet': wallet,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      name: map['name'] as String,
      wallet: map['wallet'] as String,
    );
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory Contact.fromJsonString(String jsonString) {
    return Contact.fromJson(jsonDecode(jsonString));
  }
} 