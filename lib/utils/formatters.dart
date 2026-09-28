import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  final format = NumberFormat.currency(symbol: 'Rs.', decimalDigits: 2);
  return format.format(amount);
}

String formatDate(DateTime date) {
  return DateFormat('MMM d, yyyy').format(date);
}

String formatMonth(DateTime date) {
  return DateFormat('MMMM yyyy').format(date);
}
