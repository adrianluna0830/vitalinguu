import 'package:flutter/material.dart';
import 'package:vitalinguu/core/domain/credit/credit_balance_store.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

class CreditBalanceText extends StatelessWidget {
  final CreditBalanceState state;

  const CreditBalanceText({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.account_balance_wallet_outlined, size: 18),
        const SizedBox(width: 6),
        Text(switch (state) {
          CreditBalanceNotStarted() => context.t.settings.credit.notStarted,
          CreditBalanceInProgress() => context.t.settings.credit.loading,
          CreditBalanceStateAvailable(:final balanceInUsd) =>
            context.t.settings.credit.available(
              amount: balanceInUsd.toStringAsFixed(4),
            ),
          CreditBalanceStateUnauthorized() =>
            context.t.settings.credit.unauthorized,
          CreditBalanceStateUnavailable() =>
            context.t.settings.credit.unavailable,
        }),
      ],
    );
  }
}
