import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:paganini_wallet/core/constants/colors.dart';
import 'package:paganini_wallet/core/theme/extensions/responsive_size.dart';

Future<void> showWarningDialog(
    {required BuildContext context,
    required String title,
    required String message,
    required Function() onAccept,
    bool eliminarOperation = false}) async {
  await AwesomeDialog(
          btnCancel: customWarningButtonWidget(
              onTap: () {
                Navigator.pop(context);
              },
              avaibleBorder: true,
              color: eliminarOperation ? primaryColor : Colors.red,
              label: 'Cancelar',
              context: context),
          btnOk: customWarningButtonWidget(
              onTap: () {
                Navigator.pop(context);
                onAccept();
              },
              avaibleBorder: false,
              color: eliminarOperation ? Colors.red : primaryColor,
              label: eliminarOperation ? 'Eliminar' : 'Aceptar',
              context: context),
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.warning,
          title: title,
          desc: message,
          btnOkText: 'Aceptar',
          btnCancelText: 'Cancelar')
      .show();
}

Widget customWarningButtonWidget(
    {required String label,
    required BuildContext context,
    required bool avaibleBorder,
    required Color color,
    required Function() onTap}) {
  return TextButton(
      onPressed: () => onTap(),
      style: ElevatedButton.styleFrom(
          backgroundColor: avaibleBorder ? null : color,
          padding: EdgeInsets.symmetric(
              vertical: 5.rh(context), horizontal: 5.rh(context)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side:
                  avaibleBorder ? BorderSide(color: color) : BorderSide.none)),
      child: Text(label,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: avaibleBorder ? color : Colors.white),
          overflow: TextOverflow.ellipsis));
}
