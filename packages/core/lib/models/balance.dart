double parseDouble(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) {
    final normalized = value.contains(',')
        ? value.replaceAll('.', '').replaceAll(',', '.')
        : value;
    return double.tryParse(normalized) ?? 0;
  }
  return 0;
}

class Balance {
  const Balance({required this.amount, this.currency = 'BRL'});

  final double amount;
  final String currency;

  factory Balance.fromJson(Object? raw) {
    if (raw is Map<String, dynamic>) {
      return Balance(
        amount: parseDouble(raw['amount'] ?? raw['value'] ?? raw['balance']),
        currency: '${raw['currency'] ?? 'BRL'}',
      );
    }
    return Balance(amount: parseDouble(raw));
  }
}
