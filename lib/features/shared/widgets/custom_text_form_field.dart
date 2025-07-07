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
  });
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
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(40));

    const borderRadius = Radius.circular(30);

    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(borderRadius),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 5))
            ]),
        child: Row(children: [
          Padding(
              padding: EdgeInsets.only(left: 10.rw(context)),
              child: widget.icon ?? const SizedBox(width: 0)),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(right: 10),
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
                    focusColor: colors.primary)),
          )),
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
