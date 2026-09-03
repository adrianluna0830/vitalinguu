import 'package:decimal/decimal.dart';

abstract interface class ICreditBalanceProvider {
  Future<CreditBalanceResult> getRemainingCredits(String apiKey);
}

sealed class CreditBalanceResult {
  const CreditBalanceResult();
}

final class CreditBalanceAvailable extends CreditBalanceResult {
  final Decimal balanceInUsd;

  const CreditBalanceAvailable(this.balanceInUsd);
}

final class CreditBalanceUnauthorized extends CreditBalanceResult {
  const CreditBalanceUnauthorized();
}

final class CreditBalanceUnavailable extends CreditBalanceResult {
  const CreditBalanceUnavailable();
}

abstract class CreditBalanceLimits {
  static Decimal get minimumBalanceToContinueInUsd => Decimal.parse('0.1');
}
