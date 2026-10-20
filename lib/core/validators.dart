abstract final class Validate {
  static String? required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required' : null;
  static String? email(String? value) =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value?.trim() ?? '')
      ? null
      : 'Enter a valid email address';
  static String? password(String? value) =>
      (value?.length ?? 0) >= 6 ? null : 'Use at least 6 characters';
  static String? phone(String? value) =>
      RegExp(r'^\d{7,15}$')
          .hasMatch((value ?? '').replaceAll(RegExp(r'[\s+()-]'), ''))
      ? null
      : 'Enter a valid phone number';
  static String? card(String? value) {
    final digits = (value ?? '').replaceAll(' ', '');
    if (!RegExp(r'^\d{13,19}$').hasMatch(digits)) {
      return 'Enter a valid card number';
    }
    var sum = 0;
    for (var i = 0; i < digits.length; i++) {
      var n = int.parse(digits[digits.length - 1 - i]);
      if (i.isOdd) {
        n *= 2;
        if (n > 9) {
          n -= 9;
        }
      }
      sum += n;
    }
    return sum % 10 == 0 ? null : 'Check the card number';
  }

  static String? expiry(String? value) {
    final match = RegExp(r'^(0[1-9]|1[0-2])/(\d{2})$').firstMatch(value ?? '');
    if (match == null) {
      return 'Use MM/YY';
    }
    final now = DateTime.now();
    final end = DateTime(2000 + int.parse(match[2]!), int.parse(match[1]!) + 1);
    return end.isAfter(now) ? null : 'This card has expired';
  }
}
