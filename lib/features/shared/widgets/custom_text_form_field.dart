import 'package:flutter/material.dart';
import 'package:paganini_wallet/core/theme/theme.dart';

class CustomTextFormField extends StatefulWidget {
  final String? label;
  final String? hint;
  final bool? editar;
  final String? errorMessage;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? textEditingController;
  final String? defaultText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String? Function(String?)? onSaved;
  final Widget? icon;
  final double? border;
  final bool? sombra;

  const CustomTextFormField({
    super.key,
    this.label,
    this.hint,
    this.editar = true,
    this.errorMessage,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textEditingController,
    this.defaultText,
    this.onChanged,
    this.validator,
    this.onSaved,
    this.icon,
    this.border,
    this.sombra = true,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late final TextEditingController _controller;
  late final bool _ownsController;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;

    _ownsController = widget.textEditingController == null;
    _controller = widget.textEditingController ?? TextEditingController();

    if (widget.defaultText != null) {
      _controller.text = widget.defaultText!;
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final inputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color:
            (widget.sombra ?? true) ? Colors.transparent : Colors.grey.shade400,
      ),
      borderRadius: BorderRadius.circular(widget.border ?? 40),
    );

    final radius = Radius.circular(widget.border ?? 30);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(radius),
        boxShadow: [
          BoxShadow(
            color: (widget.sombra ?? true)
                ? Colors.black.withOpacity(0.2)
                : Colors.transparent,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (widget.icon != null) const SizedBox(width: 10),
          if (widget.icon != null) widget.icon!,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextFormField(
                enabled: widget.editar,
                controller: _controller,
                onSaved: widget.onSaved,
                onChanged: widget.onChanged,
                validator: widget.validator,
                obscureText: _obscureText,
                keyboardType: widget.keyboardType,
                style: TextStyle(
                  fontSize: 14.rf(context),
                  color: Colors.black54,
                  overflow: TextOverflow.ellipsis,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  floatingLabelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.rf(context),
                  ),
                  enabledBorder: inputBorder,
                  focusedBorder: inputBorder,
                  errorBorder: inputBorder.copyWith(
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  focusedErrorBorder: inputBorder.copyWith(
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  isDense: true,
                  label: widget.label != null
                      ? Text(
                          widget.label!,
                          style: TextStyle(fontSize: 14.rf(context)),
                        )
                      : null,
                  hintText: widget.hint,
                  hintStyle: TextStyle(
                    fontSize: 12.rf(context),
                    color: Colors.black54,
                    fontWeight: FontWeight.w300,
                  ),
                  errorText: widget.errorMessage,
                  focusColor: colors.primary,
                ),
              ),
            ),
          ),
          if (widget.obscureText)
            IconButton(
              padding: const EdgeInsets.only(right: 10),
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () => setState(() => _obscureText = !_obscureText),
            ),
        ],
      ),
    );
  }
}
