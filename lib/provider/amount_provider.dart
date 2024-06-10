import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:salary_percentage/models/amount_model.dart';
import 'package:salary_percentage/utils/enums/calculation_type_enum.dart';

final toggleCalculationType =
    StateProvider<CalculationType>((ref) => CalculationType.amount);

final amountProvider = StateNotifierProvider<Amount, AmountModel>(
  (ref) => Amount(ref),
);

final amountNotifier = amountProvider.notifier;

class Amount extends StateNotifier<AmountModel> {
  final Ref ref;

  Amount(this.ref) : super(AmountModel.empty());

  setAmount(String amount, CalculationType type) {
    state = AmountModel(
      value: double.parse(amount),
      calculationType: type,
    );
  }
}

String formatNumberToUSD(num number) {
  final formatter = NumberFormat('#,##0.0#', 'en_US');
  return formatter.format(number);
}
