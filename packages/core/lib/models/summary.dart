import 'balance.dart';

class Summary {
  const Summary({
    required this.balance,
    this.cardStatus = 'Ativo',
    this.cardType = 'Estudantil',
    this.holderName = '',
    this.cardNumber = '',
  });

  final Balance balance;
  final String cardStatus;
  final String cardType;
  final String holderName;
  final String cardNumber;

  bool get isActive {
    final s = cardStatus.toLowerCase();
    return s == 'ativo' || s == 'active';
  }

  factory Summary.fromJson(Map<String, dynamic> json) {
    final rawBalance =
        json['balance'] ?? json['saldo'] ?? json['current_balance'];
    return Summary(
      balance: Balance.fromJson(rawBalance),
      cardStatus: '${json['card_status'] ?? json['status'] ?? 'Ativo'}',
      cardType: '${json['card_type'] ?? json['type'] ?? 'Estudantil'}',
      holderName: '${json['holder_name'] ?? json['name'] ?? ''}',
      cardNumber: '${json['card_number'] ?? ''}',
    );
  }
}
