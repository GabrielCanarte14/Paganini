import 'package:flutter/material.dart';
import 'package:paganini_wallet/core/constants/colors.dart';
import 'package:paganini_wallet/core/constants/typedefs.dart';

class SegmentedControl extends StatelessWidget {
  final QrTab tab;
  final ValueChanged<QrTab> onChanged;
  final String leftLabel;
  final String rightLabel;

  const SegmentedControl({
    super.key,
    required this.tab,
    required this.onChanged,
    required this.leftLabel,
    required this.rightLabel,
  });

  @override
  Widget build(BuildContext context) {
    final bg = Colors.white;
    final sel = primaryColor;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            _SegmentedButton(
              label: leftLabel,
              selected: tab == QrTab.myCode,
              onTap: () => onChanged(QrTab.myCode),
              selectedColor: sel,
            ),
            _SegmentedButton(
              label: rightLabel,
              selected: tab == QrTab.scan,
              onTap: () => onChanged(QrTab.scan),
              selectedColor: sel,
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentedButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color selectedColor;

  const _SegmentedButton({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: selected ? selectedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
