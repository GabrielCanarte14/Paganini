import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paganini_wallet/core/constants/colors.dart';
import 'package:paganini_wallet/features/shared/widgets/custom_buttom_2.dart';
import 'package:paganini_wallet/features/shared/widgets/custom_text_form_field.dart';

class AsociarCuentaScreen extends StatefulWidget {
  const AsociarCuentaScreen({super.key});

  @override
  State<AsociarCuentaScreen> createState() => _AsociarCuentaScreenState();
}

class _AsociarCuentaScreenState extends State<AsociarCuentaScreen> {
  String? selectedSwiftCode;
  String selectedAccountType = 'corriente';

  final _swiftCodes = [
    'Seleccione el código SWIFT',
    'BPCHECEQ',
    'BOFAUS3N',
    'ECUAECEQ'
  ];

  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _cardController.dispose();
    _idController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        title: Text('Asociar una cuenta bancaria',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
            overflow: TextOverflow.ellipsis),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Asegúrese de asociar una cuenta bancaria que acepte dólares estadounidenses. Esto garantiza que no se rechace la transferencia.',
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 25),
              const Text('Banco Pichincha CA',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: selectedSwiftCode,
                  isExpanded: true,
                  underline: const SizedBox(),
                  hint: const Text('Seleccione el código SWIFT'),
                  items: _swiftCodes
                      .map((code) => DropdownMenuItem(
                            value: code,
                            child: Text(code),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => selectedSwiftCode = value);
                  },
                ),
              ),
              const SizedBox(height: 25),
              const Text('Tipo de cuenta',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              RadioListTile(
                value: 'corriente',
                groupValue: selectedAccountType,
                title: Text('Cuenta corriente',
                    style:
                        textStyles.bodyMedium!.copyWith(color: Colors.black)),
                onChanged: (value) =>
                    setState(() => selectedAccountType = value.toString()),
              ),
              RadioListTile(
                value: 'ahorros',
                groupValue: selectedAccountType,
                title: Text('Cuenta de ahorros',
                    style:
                        textStyles.bodyMedium!.copyWith(color: Colors.black)),
                onChanged: (value) =>
                    setState(() => selectedAccountType = value.toString()),
              ),
              const SizedBox(height: 15),
              CustomTextFormField(
                label: 'Número de la cuenta',
                keyboardType: TextInputType.number,
                textEditingController: _cardController,
                border: 15,
                sombra: false,
                onChanged: (value) {},
              ),
              const SizedBox(height: 15),
              CustomTextFormField(
                label: 'Identificación nacional',
                keyboardType: TextInputType.text,
                textEditingController: _idController,
                border: 15,
                sombra: false,
                onChanged: (value) {},
              ),
              const SizedBox(height: 15),
              CustomTextFormField(
                label: 'Número de teléfono',
                keyboardType: TextInputType.phone,
                textEditingController: _phoneController,
                border: 15,
                sombra: false,
                onChanged: (value) {},
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: CustomButtonWidget(
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            label: 'Asociar cuenta bancaria',
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
