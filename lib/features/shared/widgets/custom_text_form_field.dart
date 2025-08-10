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

  const CustomTextFormField(
      {super.key,
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
      this.sombra = true});
  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late TextEditingController _textEditingController;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _textEditingController =
        widget.textEditingController ?? TextEditingController();
    if (widget.defaultText != null) {
      _textEditingController.text = widget.defaultText!;
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
        borderSide: BorderSide(
            color: widget.sombra! ? Colors.transparent : Colors.grey.shade400),
        borderRadius: BorderRadius.circular(widget.border ?? 40));

    final borderRadius = Radius.circular(widget.border ?? 30);

    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(borderRadius),
            boxShadow: [
              BoxShadow(
                  color: widget.sombra!
                      ? Colors.black.withOpacity(0.2)
                      : Colors.white.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5))
            ]),
        child: Row(children: [
          widget.icon != null
              ? const SizedBox(width: 10)
              : const SizedBox(width: 0),
          widget.icon ?? const SizedBox(width: 0),
          Expanded(
              child: TextFormField(
                  enabled: widget.editar,
                  onSaved: widget.onSaved,
                  onChanged: widget.onChanged,
                  validator: widget.validator,
                  obscureText: _obscureText,
                  keyboardType: widget.keyboardType,
                  style: TextStyle(
                      fontSize: 14.rf(context),
                      color: Colors.black54,
                      overflow: TextOverflow.ellipsis),
                  controller: _textEditingController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      floatingLabelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.rf(context)),
                      enabledBorder: border,
                      focusedBorder: border,
                      errorBorder: border.copyWith(
                          borderSide:
                              const BorderSide(color: Colors.transparent)),
                      focusedErrorBorder: border.copyWith(
                          borderSide:
                              const BorderSide(color: Colors.transparent)),
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
                          fontWeight: FontWeight.w300),
                      errorText: widget.errorMessage,
                      focusColor: colors.primary))),
          if (widget.obscureText)
            GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey)))
        ]));
  }
}
