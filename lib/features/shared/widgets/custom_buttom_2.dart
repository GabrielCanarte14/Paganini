import 'package:flutter/material.dart';
import 'package:paganini_wallet/core/theme/extensions/responsive_size.dart';

class CustomButtonWidget extends StatelessWidget {
  final Function() onTap;
  final Color color;
  final String label;
  final bool isEnabled;
  final IconData? iconData;
  final bool avaibleBorder;
  const CustomButtonWidget(
      {super.key,
      required this.onTap,
      required this.color,
      required this.label,
      this.isEnabled = true,
      this.avaibleBorder = false,
      this.iconData});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: () => isEnabled ? onTap() : null,
        label: Text(label,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: avaibleBorder ? color : Colors.white),
            overflow: TextOverflow.ellipsis),
        style: ElevatedButton.styleFrom(
            backgroundColor: avaibleBorder
                ? Colors.white
                : isEnabled
                    ? color
                    : Colors.grey,
            padding: EdgeInsets.symmetric(
                vertical: 10.rh(context), horizontal: 10.rh(context)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: avaibleBorder
                    ? BorderSide(color: color)
                    : BorderSide.none)),
        icon: (iconData != null)
            ? Icon(iconData, color: avaibleBorder ? color : Colors.white)
            : null);
  }
}
