import 'package:flutter/material.dart';
import 'package:paganini_wallet/features/payments_methods/data/model/models.dart';

class BankItem extends StatelessWidget {
  final BankAccountModel model;
  final VoidCallback? onLongPress;

  const BankItem({super.key, required this.model, this.onLongPress});

  String _maskCardNumber(String number) {
    final clean = number.replaceAll(' ', '');
    if (clean.length <= 4) return clean;
    final last4 = clean.substring(clean.length - 4);
    return '**** **** **** $last4';
  }

  String? _bankBgAsset(String bankName) {
    final b = bankName.toLowerCase();
    if (b.contains('pichincha')) return 'assets/img/bcoPichincha.png';
    if (b.contains('guayaquil')) return 'assets/img/bcoGuayaquil.png';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final bank = model.bank;
    final holder = model.titular;
    final number = model.number;
    final bgAsset = _bankBgAsset(bank);

    return GestureDetector(
        onLongPress: onLongPress,
        child: Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(children: [
              Positioned.fill(
                  child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Align(
                          alignment: Alignment.topRight,
                          child: Opacity(
                              opacity: 0.10,
                              child: SizedBox(
                                width: 110,
                                height: 110,
                                child: bgAsset != null
                                    ? Image.asset(bgAsset, fit: BoxFit.contain)
                                    : Icon(
                                        Icons.account_balance,
                                        size: 110,
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                              ))))),
              Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bank.isEmpty ? 'Banco' : bank,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: tt.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _maskCardNumber(number),
                          style: tt.headlineSmall?.copyWith(
                            letterSpacing: 1.5,
                            fontFeatures: const [FontFeature.tabularFigures()],
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(children: [
                          Expanded(
                              child: _labelValue(
                            label: 'TITULAR',
                            value: holder.isEmpty ? '—' : holder,
                            tt: tt,
                            cs: cs,
                          ))
                        ])
                      ]))
            ])));
  }

  Widget _labelValue({
    required String label,
    required String value,
    required TextTheme tt,
    required ColorScheme cs,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: tt.labelSmall?.copyWith(
            color: Colors.black54,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: tt.titleMedium?.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
