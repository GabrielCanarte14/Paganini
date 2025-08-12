import 'package:flutter/material.dart';

class ScanButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const ScanButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: Colors.black.withOpacity(0.55),
        child: InkWell(
          onTap: onTap,
          child: const SizedBox(
            width: 54,
            height: 54,
            child: Center(child: _IconHolder()),
          ),
        ),
      ),
    );
  }
}

class _IconHolder extends StatelessWidget {
  const _IconHolder();

  @override
  Widget build(BuildContext context) {
    final widget = context.findAncestorWidgetOfExactType<ScanButton>();
    return Icon(widget?.icon, color: Colors.white);
  }
}
