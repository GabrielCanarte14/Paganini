import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/auth/auth_bloc.dart';

class AuthLifecycleWatcher extends StatefulWidget {
  final Widget child;
  const AuthLifecycleWatcher({super.key, required this.child});

  @override
  State<AuthLifecycleWatcher> createState() => _AuthLifecycleWatcherState();
}

class _AuthLifecycleWatcherState extends State<AuthLifecycleWatcher>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final authBloc = context.read<AuthBloc>();
      final prefs = authBloc.keyValueStorageService;
      final expiresAtIso = await prefs.getValue<String>('expiresAt');

      if (expiresAtIso != null && expiresAtIso.isNotEmpty) {
        final expiresAt = DateTime.tryParse(expiresAtIso);
        if (expiresAt != null && DateTime.now().isAfter(expiresAt)) {
          authBloc.add(SessionExpiredEvent());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
