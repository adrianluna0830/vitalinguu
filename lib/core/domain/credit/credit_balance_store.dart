import 'package:decimal/decimal.dart';
import 'package:signals/signals_core.dart';
import 'package:vitalinguu/core/domain/interfaces/i_credit_balance_provider.dart';

sealed class CreditBalanceState {
  const CreditBalanceState();
}

final class CreditBalanceNotStarted extends CreditBalanceState {
  const CreditBalanceNotStarted();
}

final class CreditBalanceInProgress extends CreditBalanceState {
  const CreditBalanceInProgress();
}

final class CreditBalanceStateAvailable extends CreditBalanceState {
  final Decimal balanceInUsd;

  const CreditBalanceStateAvailable(this.balanceInUsd);
}

final class CreditBalanceStateUnauthorized extends CreditBalanceState {
  const CreditBalanceStateUnauthorized();
}

final class CreditBalanceStateUnavailable extends CreditBalanceState {
  const CreditBalanceStateUnavailable();
}

class CreditBalanceStore {
  final ICreditBalanceProvider creditBalanceProvider;

  final Signal<CreditBalanceState> _creditBalanceState = signal(
    const CreditBalanceNotStarted(),
  );
  int _refreshId = 0;

  ReadonlySignal<CreditBalanceState> get creditBalanceState =>
      _creditBalanceState.readonly();

  CreditBalanceStore({required this.creditBalanceProvider});

  Future<void> refresh(String? apiKey) async {
    final refreshId = ++_refreshId;
    _creditBalanceState.value = const CreditBalanceInProgress();

    final normalizedApiKey = apiKey?.trim();
    if (normalizedApiKey == null || normalizedApiKey.isEmpty) {
      _creditBalanceState.value = const CreditBalanceStateUnauthorized();
      return;
    }

    final result = await creditBalanceProvider.getRemainingCredits(
      normalizedApiKey,
    );
    if (refreshId != _refreshId) return;

    _creditBalanceState.value = switch (result) {
      CreditBalanceAvailable(:final balanceInUsd) =>
        CreditBalanceStateAvailable(balanceInUsd),
      CreditBalanceUnauthorized() => const CreditBalanceStateUnauthorized(),
      CreditBalanceUnavailable() => const CreditBalanceStateUnavailable(),
    };
  }
}
