import 'package:salary_percentage/utils/enums/calculation_type_enum.dart';

class AmountModel {
  final double value;
  final CalculationType calculationType;

  AmountModel({
    required this.value,
    required this.calculationType,
  });

  AmountModel.empty()
      : value = 0.0,
        calculationType = CalculationType.amount;

  AmountModel copyWith({
    double? value,
    CalculationType? calculationType,
  }) {
    return AmountModel(
      value: value ?? this.value,
      calculationType: calculationType ?? this.calculationType,
    );
  }
}
