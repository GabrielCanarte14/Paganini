import 'package:flutter/material.dart';
import 'package:paganini_wallet/core/theme/theme.dart';
import 'package:paganini_wallet/features/shared/widgets/ui_utils.dart';

class CheckAuthStatusScreen extends StatelessWidget {
  const CheckAuthStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            UiUtils.progress(width: 150.rw(context), height: 150.rh(context)),
      ),
    );
  }
}
