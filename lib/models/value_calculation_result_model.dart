class ValueCalculationResult {
  final ({double? value, bool isEmpty})? percentageOfValue;
  final ({double? value, bool isEmpty})? increaseValueInPercentage;
  final ({double? value, bool isEmpty})? decreaseValueInPercentage;
  final ({double? value, bool isEmpty})? valuePercentageOfValue;

  ValueCalculationResult({
    this.percentageOfValue,
    this.increaseValueInPercentage,
    this.decreaseValueInPercentage,
    this.valuePercentageOfValue,
  });

  static const ValueCalculationResult instance = ValueCalculationResult.empty();

  const ValueCalculationResult.empty()
      : percentageOfValue = null,
        increaseValueInPercentage = null,
        decreaseValueInPercentage = null,
        valuePercentageOfValue = null;

  ValueCalculationResult copyWith({
    ({double? value, bool isEmpty})? percentageOfValue,
    ({double? value, bool isEmpty})? increaseValueInPercentage,
    ({double? value, bool isEmpty})? decreaseValueInPercentage,
    ({double? value, bool isEmpty})? valuePercentageOfValue,
  }) =>
      ValueCalculationResult(
        percentageOfValue: percentageOfValue ?? this.percentageOfValue,
        increaseValueInPercentage:
            increaseValueInPercentage ?? this.increaseValueInPercentage,
        decreaseValueInPercentage:
            decreaseValueInPercentage ?? this.decreaseValueInPercentage,
        valuePercentageOfValue:
            valuePercentageOfValue ?? this.valuePercentageOfValue,
      );
}
