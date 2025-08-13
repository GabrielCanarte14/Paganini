import 'package:intl/intl.dart';
import 'package:paganini_wallet/core/constants/constants.dart';

String accountTypeToString(AccountType activityState) {
  return activityState == AccountType.ahorro ? 'ahorro' : 'corriente';
}

AccountType stringToAccountType(String tipo) {
  return tipo == 'ahorro' ? AccountType.ahorro : AccountType.corriente;
}

String formatCurrencyEsFromRaw(String raw) {
  double value;
  if (raw.isEmpty || raw == '.') {
    value = 0.0;
  } else {
    value = double.tryParse(raw) ?? 0.0;
  }
  final nf = NumberFormat.currency(
    locale: 'es_ES',
    symbol: r'$ ',
    decimalDigits: 2,
  );
  return nf
      .format(value)
      .replaceAll('.', '#')
      .replaceAll(',', ',')
      .replaceAll('#', '.');
}

class Formatters {
  static String dateYmd(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String currency(double amount,
      {String locale = 'es_EC', String symbol = r'$'}) {
    return NumberFormat.currency(locale: locale, symbol: symbol).format(amount);
  }
}
