import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:paganini_wallet/features/auth/presentation/bloc/auth/auth_bloc.dart';

class AuthBlocListenable extends ChangeNotifier {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> _subscription;

  AuthBlocListenable(this.authBloc) {
    _subscription = authBloc.stream.listen((state) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
