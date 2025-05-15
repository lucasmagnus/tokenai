import 'package:intl/intl.dart';

class Formatters {
  static final _dateFormat = DateFormat('MMM dd, yyyy HH:mm');
  static final _numberFormat = NumberFormat.currency(
    symbol: '',
    decimalDigits: 2,
  );

  static String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return _dateFormat.format(date);
    } catch (e) {
      return dateString;
    }
  }

  static String formatAmount(String? amount) {
    if (amount == null) return '0.00';
    try {
      final value = double.parse(amount);
      return _numberFormat.format(value);
    } catch (e) {
      return amount;
    }
  }
} 