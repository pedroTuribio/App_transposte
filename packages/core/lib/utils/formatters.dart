abstract final class BrFormat {
  static const _months = [
    'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
    'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez',
  ];

  /// 1234.5 -> "R$ 1.234,50"
  static String currency(double value) {
    final negative = value < 0;
    final cents = (value.abs() * 100).round();
    final intPart = (cents ~/ 100).toString();
    final decPart = (cents % 100).toString().padLeft(2, '0');
    final buffer = StringBuffer();
    for (var i = 0; i < intPart.length; i++) {
      final remaining = intPart.length - i;
      buffer.write(intPart[i]);
      if (remaining > 1 && remaining % 3 == 1) buffer.write('.');
    }
    return '${negative ? '-' : ''}R\$ $buffer,$decPart';
  }

  static String _two(int n) => n.toString().padLeft(2, '0');

  /// "05/10/2026 às 14:30"
  static String dateTime(DateTime d) =>
      '${_two(d.day)}/${_two(d.month)}/${d.year} às ${_two(d.hour)}:${_two(d.minute)}';

  /// "Out/26"
  static String monthLabel(DateTime d) =>
      '${_months[d.month - 1]}/${_two(d.year % 100)}';
}

abstract final class CpfUtils {
  static String digitsOnly(String value) => value.replaceAll(RegExp(r'\D'), '');

  /// "12345678909" -> "123.456.789-09"
  static String format(String value) {
    final digits = digitsOnly(value);
    final clipped = digits.length > 11 ? digits.substring(0, 11) : digits;
    final b = StringBuffer();
    for (var i = 0; i < clipped.length; i++) {
      if (i == 3 || i == 6) b.write('.');
      if (i == 9) b.write('-');
      b.write(clipped[i]);
    }
    return b.toString();
  }

  /// "12345678909" -> "123.***.***-09"
  static String mask(String value) {
    final d = digitsOnly(value);
    if (d.length != 11) return value.isEmpty ? '---' : value;
    return '${d.substring(0, 3)}.***.***-${d.substring(9)}';
  }

  static bool isValid(String value) {
    final d = digitsOnly(value);
    if (d.length != 11 || RegExp(r'^(\d)\1{10}$').hasMatch(d)) return false;
    int check(int len) {
      var sum = 0;
      for (var i = 0; i < len; i++) {
        sum += int.parse(d[i]) * (len + 1 - i);
      }
      final r = (sum * 10) % 11;
      return r == 10 ? 0 : r;
    }

    return check(9) == int.parse(d[9]) && check(10) == int.parse(d[10]);
  }
}
