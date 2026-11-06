import 'balance.dart';

enum TransactionType { recharge, trip }

class Transaction {
  const Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.date,
  });

  final String id;
  final String description;
  final double amount; // sempre positivo; o sinal vem do [type]
  final TransactionType type;
  final DateTime date;

  bool get isRecharge => type == TransactionType.recharge;

  factory Transaction.fromJson(Map<String, dynamic> json) {
    final amount = parseDouble(json['amount'] ?? json['value']);
    final typeText = '${json['type'] ?? json['kind'] ?? ''}'.toLowerCase();
    final TransactionType type;
    if (RegExp(r'recharge|recarga|credit|deposit|income').hasMatch(typeText)) {
      type = TransactionType.recharge;
    } else if (RegExp(r'trip|passagem|debit|bus|ride|onibus|expense|transfer')
        .hasMatch(typeText)) {
      type = TransactionType.trip;
    } else {
      type = amount >= 0 ? TransactionType.recharge : TransactionType.trip;
    }
    final rawDate =
        '${json['date'] ?? json['created_at'] ?? json['timestamp'] ?? ''}';
    final description =
        '${json['description'] ?? json['title'] ?? json['merchant'] ?? ''}';
    return Transaction(
      id: '${json['id'] ?? ''}',
      description: description.isEmpty
          ? (type == TransactionType.recharge ? 'Recarga' : 'Passagem de ônibus')
          : description,
      amount: amount.abs(),
      type: type,
      date: DateTime.tryParse(rawDate)?.toLocal() ?? DateTime.now(),
    );
  }
}
