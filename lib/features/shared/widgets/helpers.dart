String maskPhone(String phone) {
  final onlyDigits = phone.replaceAll(RegExp(r'\D'), '');
  if (onlyDigits.length <= 4) return 'xxxx-xxxx-${onlyDigits.padLeft(4, 'x')}';
  final last4 = onlyDigits.substring(onlyDigits.length - 4);
  return 'xxxx-xxxx-$last4';
}
