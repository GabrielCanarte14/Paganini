import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/core/constants/colors.dart';
import 'package:paganini_wallet/features/shared/widgets/custom_buttom_2.dart';
import 'package:paganini_wallet/features/shared/widgets/custom_text_form_field.dart';
import 'package:paganini_wallet/features/payments_methods/presentation/bloc/methods/methods_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AsociarCuentaScreen extends StatefulWidget {
  final String banco;
  final String email;
  const AsociarCuentaScreen(
      {required this.banco, required this.email, super.key});

  @override
  State<AsociarCuentaScreen> createState() => _AsociarCuentaScreenState();
}

class _AsociarCuentaScreenState extends State<AsociarCuentaScreen> {
  String selectedAccountType = 'corriente';

  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _titularController = TextEditingController();

  @override
  void dispose() {
    _cardController.dispose();
    _idController.dispose();
    _titularController.dispose();
    super.dispose();
  }

  void _toast(String msg) => showTopSnackBar(
      Overlay.of(context), CustomSnackBar.success(message: msg));

  void _toastError(String msg) {
    showTopSnackBar(Overlay.of(context), CustomSnackBar.error(message: msg));
  }

  void _submit() {
    final numero = _cardController.text.trim();
    final id = _idController.text.trim();
    final titular = _titularController.text.trim();

    if (numero.isEmpty) return _toastError('Ingresa el número de cuenta');
    if (id.isEmpty) return _toastError('Ingresa la identificación');
    if (titular.isEmpty) return _toastError('Ingresa el titular');

    final tipoApi = selectedAccountType == 'corriente' ? 'Corriente' : 'Ahorro';
    context.read<MethodsBloc>().add(
          RegisterBankEvent(
            number: numero,
            bank: widget.banco,
            identificacion: id,
            titular: titular,
            type: tipoApi,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        title: Text(
          'Asociar una cuenta bancaria',
          style: textStyles.titleMedium!.copyWith(color: Colors.white),
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
          if (state is MethodsError) _toast(state.message);
          if (state is Agregado) {
            _toast(state.message);
            context
                .read<MethodsBloc>()
                .add(GetMethodsEvent(email: widget.email));
            Navigator.pop(context);
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final isLoading = state is Checking;
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.banco,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 25),
                      Text('Tipo de cuenta',
                          style: textStyles.bodyMedium!
                              .copyWith(color: Colors.black87)),
                      RadioListTile(
                        value: 'corriente',
                        groupValue: selectedAccountType,
                        title: Text('Cuenta corriente',
                            style: textStyles.bodyMedium!
                                .copyWith(color: Colors.black)),
                        onChanged: (value) => setState(
                            () => selectedAccountType = value.toString()),
                      ),
                      RadioListTile(
                        value: 'ahorros',
                        groupValue: selectedAccountType,
                        title: Text('Cuenta de ahorros',
                            style: textStyles.bodyMedium!
                                .copyWith(color: Colors.black)),
                        onChanged: (value) => setState(
                            () => selectedAccountType = value.toString()),
                      ),
                      const SizedBox(height: 15),
                      CustomTextFormField(
                        label: 'Número de la cuenta',
                        keyboardType: TextInputType.number,
                        textEditingController: _cardController,
                        border: 15,
                        sombra: false,
                      ),
                      const SizedBox(height: 15),
                      CustomTextFormField(
                        label: 'Identificación nacional',
                        keyboardType: TextInputType.text,
                        textEditingController: _idController,
                        border: 15,
                        sombra: false,
                      ),
                      const SizedBox(height: 15),
                      CustomTextFormField(
                        label: 'Titular',
                        keyboardType: TextInputType.text,
                        textEditingController: _titularController,
                        border: 15,
                        sombra: false,
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.12),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: BlocBuilder<MethodsBloc, MethodsState>(
            builder: (context, state) {
              final isLoading = state is Checking;
              return CustomButtonWidget(
                onTap: isLoading ? () {} : _submit,
                label: isLoading ? 'Guardando…' : 'Asociar cuenta bancaria',
                color: primaryColor,
              );
            },
          ),
        ),
      ),
    );
  }
}
