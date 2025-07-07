// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paganini_wallet/features/shared/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

Text heading({var label, Color color = Colors.black}) {
  return Text(label,
      style: TextStyle(
          color: color,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'bold'),
      textAlign: TextAlign.left);
}

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
      heading(label: "ACCESO A LOCALIZACIÓN"),
      const SizedBox(height: 10),
      const Padding(
          padding: EdgeInsets.fromLTRB(40, 16, 40, 16),
          child: Text(
              'Esta aplicación requiere acceso a tu ubicación para monitorear el estado del envío y mostrar la ubicación del dispositivo en el mapa. La ubicación se utiliza con la aplicación abierta y en segundo plano para ofrecerte una experiencia de seguimiento en tiempo real.',
              textAlign: TextAlign.center)),
      const SizedBox(height: 40),
      Padding(
          padding: const EdgeInsets.fromLTRB(40, 16, 40, 16),
          child: CustomButton(
              buttonTitle: "Iniciar",
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('seen', true);
                GoRouter.of(context).go('/login');
              }))
    ])));
  }
}
