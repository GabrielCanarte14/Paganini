import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:paganini_wallet/core/constants/colors.dart';
import 'package:paganini_wallet/features/shared/widgets/custom_buttom_2.dart';
import 'package:paganini_wallet/features/payments_methods/presentation/bloc/methods/methods_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RegistroTarjetaScreen extends StatefulWidget {
  final String email;
  const RegistroTarjetaScreen({required this.email, super.key});

  @override
  State<RegistroTarjetaScreen> createState() => _RegistroTarjetaScreenState();
}

class _RegistroTarjetaScreenState extends State<RegistroTarjetaScreen> {
  String cardNumber = '';
  String cardHolder = 'Propietario';
  String expiryDate = '';
  String cvv = '';
  bool showBack = false;
  String? network;

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
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32.0,
                        scrollController: FixedExtentScrollController(
                            initialItem: selectedMonth),
                        onSelectedItemChanged: (index) => selectedMonth = index,
                        children:
                            months.map((m) => Center(child: Text(m))).toList(),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32.0,
                        scrollController: FixedExtentScrollController(
                            initialItem: selectedYear),
                        onSelectedItemChanged: (index) => selectedYear = index,
                        children:
                            years.map((y) => Center(child: Text(y))).toList(),
                      ),
                    ),
                  ],
                ),
              ),
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
            ],
          ),
        );
      },
    );
  }

  void _submit() {
    final numberDigits = cardNumber.replaceAll(' ', '');
    if (numberDigits.length < 13) {
      _toastError('Número de tarjeta inválido');
      return;
    }
    if (cardHolder.trim().isEmpty) {
      _toastError('Ingresa el nombre del titular');
      return;
    }
    if (expiryDate.isEmpty || !expiryDate.contains('/')) {
      _toastError('Selecciona el vencimiento');
      return;
    }
    if (cvv.length < 3) {
      _toastError('CVV inválido');
      return;
    }

    final parts = expiryDate.split('/');
    final month = parts[0];
    final yy = parts[1];
    final year = yy.length == 2 ? '20$yy' : yy;

    final type = 'C';
    final red = (network ?? '').toUpperCase();

    context.read<MethodsBloc>().add(
          RegisterCardEvent(
            number: numberDigits,
            titular: cardHolder.trim(),
            month: int.parse(month),
            year: int.parse(year),
            cvv: cvv,
            type: type,
            red: red,
          ),
        );
  }

  void _toast(String msg) {
    showTopSnackBar(Overlay.of(context), CustomSnackBar.success(message: msg));
  }

  void _toastError(String msg) {
    showTopSnackBar(Overlay.of(context), CustomSnackBar.error(message: msg));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
      body: BlocConsumer<MethodsBloc, MethodsState>(
        listener: (context, state) {
          if (state is MethodsError) {
            _toastError(state.message);
          }
          if (state is Agregado) {
            _toast(state.message);
            context
                .read<MethodsBloc>()
                .add(GetMethodsEvent(email: widget.email));
            context.pop();
          }
        },
        builder: (context, state) {
          final isLoading = state is Checking;

          return Stack(
            children: [
              SingleChildScrollView(
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
                      onCreditCardWidgetChange: (brand) {
                        final newNetwork = _mapBrandToNetwork(brand);
                        if (network != newNetwork) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (!mounted) return;
                            setState(() => network = newNetwork);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 60),
                    _buildTextField(
                      controller: nameController,
                      label: 'Nombre',
                      onChanged: (v) => setState(() => cardHolder = v),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]')),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: numberController,
                      label: 'Número de la tarjeta',
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final formatted = _formatCardNumber(value);
                        setState(() => cardNumber = formatted);
                        numberController.value = TextEditingValue(
                          text: formatted,
                          selection:
                              TextSelection.collapsed(offset: formatted.length),
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
                            onChanged: (v) => setState(() => cvv = v),
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
                    const SizedBox(height: 24),
                    if (network != null && network!.isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Red detectada: $network',
                            style: textTheme.bodySmall
                                ?.copyWith(color: Colors.black54)),
                      ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.15),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: BlocBuilder<MethodsBloc, MethodsState>(
            builder: (context, state) {
              final isLoading = state is Checking;
              return CustomButtonWidget(
                onTap: isLoading ? () {} : _submit,
                color: primaryColor,
                label: isLoading ? 'Guardando…' : 'Vincular',
              );
            },
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

  String _mapBrandToNetwork(CreditCardBrand brand) {
    switch (brand.brandName) {
      case CardType.visa:
        return 'VISA';
      case CardType.mastercard:
        return 'MASTERCARD';
      case CardType.americanExpress:
        return 'AMEX';
      default:
        return 'VISA';
    }
  }
}
