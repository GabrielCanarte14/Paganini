import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumKeypad extends StatelessWidget {
  const NumKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    this.decimalVisual = ',',
  });

  final void Function(String d) onDigit; // usa '.' para decimal interno
  final VoidCallback onBackspace;
  final String decimalVisual;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _KeyRow(children: [
          _KeyButton(label: '1', onTap: () => onDigit('1')),
          _KeyButton(label: '2', onTap: () => onDigit('2')),
          _KeyButton(label: '3', onTap: () => onDigit('3')),
        ]),
        const SizedBox(height: 10),
        _KeyRow(children: [
          _KeyButton(label: '4', onTap: () => onDigit('4')),
          _KeyButton(label: '5', onTap: () => onDigit('5')),
          _KeyButton(label: '6', onTap: () => onDigit('6')),
        ]),
        const SizedBox(height: 10),
        _KeyRow(children: [
          _KeyButton(label: '7', onTap: () => onDigit('7')),
          _KeyButton(label: '8', onTap: () => onDigit('8')),
          _KeyButton(label: '9', onTap: () => onDigit('9')),
        ]),
        const SizedBox(height: 10),
        _KeyRow(children: [
          _KeyButton(label: decimalVisual, onTap: () => onDigit('.')),
          _KeyButton(label: '0', onTap: () => onDigit('0')),
          _IconKey(onTap: () {
            HapticFeedback.selectionClick();
            onBackspace();
          }),
        ]),
      ],
    );
  }
}

class _KeyRow extends StatelessWidget {
  const _KeyRow({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < children.length; i++) ...[
          Expanded(child: children[i]),
          if (i != children.length - 1) const SizedBox(width: 10),
        ]
      ],
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5, // igual a tu versión
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _IconKey extends StatelessWidget {
  const _IconKey({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: const Center(
          child: Icon(Icons.backspace_outlined, size: 26),
        ),
      ),
    );
  }
}
