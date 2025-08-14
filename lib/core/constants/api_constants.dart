import 'package:paganini_wallet/core/constants/constants.dart';

const String dsnSentry =
    'https://dee15fdb253233a7311f004f88380f2b@o4509623548903424.ingest.us.sentry.io/4509623573872640';

final apiUrl = Environment.apiUrl;
final loginUrl = "${apiUrl}auth/login";
final registerUserUrl = '${apiUrl}auth/signup';
final getUserDataUrl = '${apiUrl}users';
final forgotPasswordUrl = '${apiUrl}auth/forgot-password';
final resetPasswordUrl = '${apiUrl}auth/confirm-forgot-password';
final getPaymentMethodsUrl = '${apiUrl}payment-methods/by-user';
final registerPaymentMethodUrl = '${apiUrl}payment-methods';
final deletePaymentMethodUrl = '${apiUrl}payment-methods/';
final contactsUrl = '${apiUrl}users/';
final paymentUrl = '${apiUrl}api/transacciones/enviar/correo';
final generateQrUrl = '${apiUrl}transactions/payment-requests';
