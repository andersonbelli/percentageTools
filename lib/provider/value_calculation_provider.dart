import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salary_percentage/models/value_calculation_result_model.dart';
import 'package:salary_percentage/provider/amount_provider.dart';

final valueCalculationProvider =
    StateNotifierProvider<ValueCalculation, ValueCalculationResult>(
  (ref) => ValueCalculation(ref),
);

final valueCalculationNotifier = valueCalculationProvider.notifier;

class ValueCalculation extends StateNotifier<ValueCalculationResult> {
  final Ref ref;

  ValueCalculation(this.ref) : super(ValueCalculationResult.instance);

  double get _amountValue => ref.read(amountNotifier).state.value;

  calculatePercentageOfValue(int percentage) {
    final result = _amountValue * percentage / 100;

    state = state.copyWith(percentageOfValue: (value: result, isEmpty: false));
  }

  clearPercentageOfValue() =>
      state = state.copyWith(percentageOfValue: (value: null, isEmpty: true));

  calculateIncreaseValueInPercentage(int percentage) {
    final result = _amountValue + (_amountValue * (percentage / 100));

    state = state
        .copyWith(increaseValueInPercentage: (value: result, isEmpty: false));
  }

  clearIncreaseValueInPercentage() => state =
      state.copyWith(increaseValueInPercentage: (value: null, isEmpty: true));

  calculateDecreaseValueInPercentage(int percentage) {
    final result = _amountValue - (_amountValue * (percentage / 100));

    state = state
        .copyWith(decreaseValueInPercentage: (value: result, isEmpty: false));
  }

  clearDecreaseValueInPercentage() => state =
      state.copyWith(decreaseValueInPercentage: (value: null, isEmpty: true));

  calculateValuePercentageOfValue(int value) {
    final result = (_amountValue / value) * 100;

    state =
        state.copyWith(valuePercentageOfValue: (value: result, isEmpty: false));
  }

  clearValuePercentageOfValue() => state =
      state.copyWith(valuePercentageOfValue: (value: null, isEmpty: true));

  clearState() => state = ValueCalculationResult.instance;
}
