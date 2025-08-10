import 'package:paganini_wallet/core/constants/constants.dart';

String accountTypeToString(AccountType activityState) {
  return activityState == AccountType.ahorro ? 'ahorro' : 'corriente';
}

AccountType stringToAccountType(String tipo) {
  return tipo == 'ahorro' ? AccountType.ahorro : AccountType.corriente;
}
