import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:go_router/go_router.dart';
import 'package:paganini_wallet/core/constants/colors.dart';
import 'package:paganini_wallet/features/shared/widgets/custom_buttom_2.dart';

class RegistroTarjetaScreen extends StatefulWidget {
  const RegistroTarjetaScreen({super.key});

  @override
  State<RegistroTarjetaScreen> createState() => _RegistroTarjetaScreenState();
}

class _RegistroTarjetaScreenState extends State<RegistroTarjetaScreen> {
  String cardNumber = '';
  String cardHolder = 'Propietario';
  String expiryDate = '';
  String cvv = '';
  bool showBack = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  final List<String> months =
      List.generate(12, (i) => (i + 1).toString().padLeft(2, '0'));
  final List<String> years =
      List.generate(15, (i) => (DateTime.now().year + i).toString());

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  String _formatCardNumber(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    final chunks = <String>[];
    for (var i = 0; i < digits.length; i += 4) {
      final end = (i + 4 < digits.length) ? i + 4 : digits.length;
      chunks.add(digits.substring(i, end));
    }
    return chunks.join(' ');
  }

  void _showExpiryPicker() {
    int selectedMonth = 0;
    int selectedYear = 0;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
            height: 250,
            child: Column(children: [
              Expanded(
                  child: Row(children: [
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 32.0,
                    scrollController:
                        FixedExtentScrollController(initialItem: selectedMonth),
                    onSelectedItemChanged: (index) => selectedMonth = index,
                    children:
                        months.map((m) => Center(child: Text(m))).toList(),
                  ),
                ),
                Expanded(
                    child: CupertinoPicker(
                  itemExtent: 32.0,
                  scrollController:
                      FixedExtentScrollController(initialItem: selectedYear),
                  onSelectedItemChanged: (index) => selectedYear = index,
                  children: years.map((y) => Center(child: Text(y))).toList(),
                ))
              ])),
              TextButton(
                onPressed: () {
                  final selected =
                      '${months[selectedMonth]}/${years[selectedYear].substring(2)}';
                  setState(() => expiryDate = selected);
                  expiryController.text = selected;
                  Navigator.pop(context);
                },
                child: const Text('Aceptar'),
              ),
            ]));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      appBar: AppBar(
        titleSpacing: 25,
        centerTitle: false,
        title: Text(
          'Vincular tarjeta',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(
          children: [
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolder,
              cvvCode: cvv,
              showBackView: showBack,
              isHolderNameVisible: true,
              obscureCardCvv: true,
              obscureCardNumber: true,
              cardBgColor: Colors.black,
              onCreditCardWidgetChange: (brand) {},
            ),
            const SizedBox(height: 60),
            _buildTextField(
              controller: nameController,
              label: 'Nombre',
              onChanged: (value) => setState(() => cardHolder = value),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
              ],
            ),
            const SizedBox(height: 15),
            _buildTextField(
              controller: numberController,
              label: 'Número de la tarjeta',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final formatted = _formatCardNumber(value);
                final sel = numberController.selection;
                setState(() => cardNumber = formatted);
                numberController.value = TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: formatted.length),
                  composing: TextRange.empty,
                );
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                LengthLimitingTextInputFormatter(19),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: expiryController,
                    label: 'Vencimiento',
                    keyboardType: TextInputType.none,
                    readOnly: true,
                    onChanged: (_) {},
                    onTap: _showExpiryPicker,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: cvvController,
                    label: 'CVV',
                    keyboardType: TextInputType.number,
                    onChanged: (value) => setState(() => cvv = value),
                    onFocusChange: (focused) =>
                        setState(() => showBack = focused),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: CustomButtonWidget(
            onTap: () => context.pop(),
            color: primaryColor,
            label: 'Vincular',
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
    Function(bool)? onFocusChange,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Focus(
      onFocusChange: onFocusChange,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        readOnly: readOnly,
        onTap: onTap,
      ),
    );
  }
}
