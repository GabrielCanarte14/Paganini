import 'package:flutter/material.dart';
import 'package:paganini_wallet/core/constants/colors.dart';
import 'package:paganini_wallet/features/payments_methods/presentation/screens/asociar_cuenta_screen.dart';

class SeleccionEntidadBancariaScreen extends StatefulWidget {
  const SeleccionEntidadBancariaScreen({super.key});

  @override
  State<SeleccionEntidadBancariaScreen> createState() =>
      _SeleccionEntidadBancariaScreenState();
}

class _SeleccionEntidadBancariaScreenState
    extends State<SeleccionEntidadBancariaScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _bancos = [
    'Asociación Mutualista De Ahorro Y Credito Para La Vivienda Pichincha',
    'Banco Amazonas SA',
    'Banco Bolivariano CA',
    'Banco Pichincha CA',
  ];

  String _search = '';

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final bancosFiltrados = _bancos
        .where((banco) =>
            banco.toLowerCase().contains(_search.toLowerCase().trim()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 25,
        centerTitle: false,
        title: Text('Entidad bancaria',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 15),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _search = value),
              decoration: InputDecoration(
                hintText: 'Buscar por nombre',
                hintStyle: textStyles.bodyMedium!.copyWith(color: Colors.black),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: bancosFiltrados.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, index) {
                final banco = bancosFiltrados[index];
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListTile(
                    leading: const CircleAvatar(backgroundColor: Colors.grey),
                    title: Text(
                      banco,
                      style:
                          textStyles.bodyMedium!.copyWith(color: Colors.black),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const AsociarCuentaScreen(),
                      ));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
