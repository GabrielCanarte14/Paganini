import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/core/constants/colors.dart';
import 'package:paganini_wallet/core/utils/show_warning_dialog_widget.dart';
import 'package:paganini_wallet/features/qr/data/model/contact_model.dart';
import 'package:paganini_wallet/features/qr/presentation/screens/payment_ammount_screen.dart';
import 'package:paganini_wallet/features/qr/presentation/widgets/widgets.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../shared/widgets/widgets.dart';
import '../bloc/contactos/contactos_bloc.dart';

class ContactosScreen extends StatefulWidget {
  const ContactosScreen({super.key});

  @override
  State<ContactosScreen> createState() => _ContactosScreenState();
}

class _ContactosScreenState extends State<ContactosScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  List<ContactModel> _all = [];
  List<ContactModel> _filtered = [];
  Completer<void>? _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onQuery);
    context.read<ContactosBloc>().add(GetContactosEvent());
  }

  @override
  void dispose() {
    _searchCtrl
      ..removeListener(_onQuery)
      ..dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _applyFilter() {
    final q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = List.of(_all);
      } else {
        _filtered = _all.where((c) {
          final fullName = '${c.nombre} ${c.apellido}'.toLowerCase();
          final phone = c.celular.replaceAll(' ', '');
          final email = c.correo.toLowerCase();
          return fullName.contains(q) || phone.contains(q) || email.contains(q);
        }).toList();
      }
    });
  }

  void _onQuery() => _applyFilter();

  Future<void> _onRefresh() {
    _refreshCompleter = Completer<void>();
    context.read<ContactosBloc>().add(GetContactosEvent());
    return _refreshCompleter!.future;
  }

  Future<void> _onAddContact() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => BlocProvider.value(
        value: context.read<ContactosBloc>(),
        child: const AddContactSheet(),
      ),
    );
  }

  void _onTapContact(ContactModel c) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SendMoneyScreen(
          name: c.nombre,
          email: c.correo,
          qr: false,
        ),
      ),
    );
  }

  void _confirmDeleteContacto(BuildContext context, String correo) {
    showWarningDialog(
      context: context,
      title: 'Eliminar contacto',
      message: '¿Estás seguro de eliminar este contacto?\n$correo',
      eliminarOperation: true,
      onAccept: () {
        context.read<ContactosBloc>().add(DeleteContactoEvent(correo: correo));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        titleSpacing: 25,
        centerTitle: false,
        title: Text(
          'Enviar dinero',
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
      body: BlocConsumer<ContactosBloc, ContactosState>(
        listenWhen: (prev, curr) =>
            curr is ContactoError ||
            curr is Complete ||
            curr is Agregado ||
            curr is ContactoElimindo,
        listener: (context, state) {
          if (state is ContactoError) {
            showTopSnackBar(Overlay.of(context),
                CustomSnackBar.error(message: state.message));
            _refreshCompleter?.complete();
            _refreshCompleter = null;
          } else if (state is Agregado) {
            showTopSnackBar(Overlay.of(context),
                CustomSnackBar.success(message: 'Contacto agregado'));
            context.read<ContactosBloc>().add(GetContactosEvent());
          } else if (state is ContactoElimindo) {
            showTopSnackBar(Overlay.of(context),
                CustomSnackBar.success(message: state.message));
            context.read<ContactosBloc>().add(GetContactosEvent());
          } else if (state is Complete) {
            _all = state.contactos;
            _applyFilter();
            _refreshCompleter?.complete();
            _refreshCompleter = null;
          }
        },
        buildWhen: (prev, curr) => true,
        builder: (context, state) {
          final isLoading = state is Checking && _all.isEmpty;
          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: SearchField(
                          controller: _searchCtrl,
                          focusNode: _searchFocus,
                          hint: 'Buscar por nombre, correo o celular',
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconSquareButton(
                        icon: Icons.person_add_alt_1_rounded,
                        onTap: _onAddContact,
                        tooltip: 'Agregar contacto',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : (_filtered.isEmpty
                            ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: const [
                                  SizedBox(height: 120),
                                  Center(child: EmptyState()),
                                ],
                              )
                            : ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                itemCount: _filtered.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 6),
                                itemBuilder: (context, i) {
                                  final c = _filtered[i];
                                  final fullName = '${c.nombre} ${c.apellido}';
                                  return InkWell(
                                    onLongPress: () {
                                      HapticFeedback.selectionClick();
                                      _confirmDeleteContacto(context, c.correo);
                                    },
                                    child: ContactTile(
                                      name: fullName,
                                      subtitle: maskPhone(c.celular),
                                      onTap: () => _onTapContact(c),
                                      primaryColor: primaryColor,
                                    ),
                                  );
                                },
                              )),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
