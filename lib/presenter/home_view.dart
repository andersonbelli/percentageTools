import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salary_percentage/models/amount_model.dart';
import 'package:salary_percentage/presenter/amount_view.dart';
import 'package:salary_percentage/provider/amount_provider.dart';
import 'package:salary_percentage/provider/value_calculation_provider.dart';
import 'package:salary_percentage/utils/enums/calculation_type_enum.dart';
import 'package:salary_percentage/utils/string_extension.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amount = ref.watch(amountProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${amount.calculationType.name.capitalize()} of ${amount.value}',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  IconButton(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return AmountView(
                          nextButton: () {
                            ref
                                .read(valueCalculationProvider.notifier)
                                .clearState();
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ],
              ),
              const Divider(),
              if (amount.calculationType == CalculationType.amount)
                AmountCards(amount: amount),
              if (amount.calculationType == CalculationType.percentage)
                Row(
                  children: [
                    Text('The amount ${amount.value} '),
                    const Expanded(
                      child: TextField(),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AmountCards extends HookConsumerWidget {
  const AmountCards({
    super.key,
    required this.amount,
  });

  final AmountModel amount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(valueCalculationNotifier);

    final provider = ref.watch(valueCalculationProvider);
    final valueCalculationResult = provider;

    return Column(
      children: [
        ValueCard(
          titleText: '% of value',
          trailingText:
              '% of ${amount.value} = ${valueCalculationResult.percentageOfValue?.value}',
          valueCalculationResult: (
            value: valueCalculationResult.percentageOfValue?.value,
            isEmpty: valueCalculationResult.percentageOfValue?.isEmpty ?? true,
          ),
          onClear: () => notifier.clearPercentageOfValue(),
          onCalculate: notifier.calculatePercentageOfValue,
        ),
        ValueCard(
          titleText: 'increase: value + %',
          leadingText: '${amount.value} +',
          trailingText:
              '% = ${valueCalculationResult.increaseValueInPercentage?.value}',
          valueCalculationResult: (
            value: valueCalculationResult.increaseValueInPercentage?.value,
            isEmpty:
                valueCalculationResult.increaseValueInPercentage?.isEmpty ??
                    true,
          ),
          onClear: () => notifier.clearIncreaseValueInPercentage(),
          onCalculate: notifier.calculateIncreaseValueInPercentage,
        ),
        ValueCard(
          titleText: 'decrease: value - %',
          leadingText: '${amount.value} -',
          trailingText:
              '% = ${valueCalculationResult.decreaseValueInPercentage?.value}',
          valueCalculationResult: (
            value: valueCalculationResult.decreaseValueInPercentage?.value,
            isEmpty:
                valueCalculationResult.decreaseValueInPercentage?.isEmpty ??
                    true,
          ),
          onClear: () => notifier.clearDecreaseValueInPercentage(),
          onCalculate: notifier.calculateDecreaseValueInPercentage,
        ),
        ValueCard(
          titleText: 'value percentage of value',
          leadingText: '${amount.value} is what % of ',
          trailingText: '',
          resultText:
              ' = ${valueCalculationResult.valuePercentageOfValue?.value}%',
          valueCalculationResult: (
            value: valueCalculationResult.valuePercentageOfValue?.value,
            isEmpty:
                valueCalculationResult.valuePercentageOfValue?.isEmpty ?? true,
          ),
          onClear: () => notifier.clearValuePercentageOfValue(),
          onCalculate: notifier.calculateValuePercentageOfValue,
        ),
      ],
    );
  }
}

class ValueCard extends StatelessWidget {
  const ValueCard({
    super.key,
    required this.titleText,
    required this.valueCalculationResult,
    required this.onClear,
    required this.onCalculate,
    this.leadingText = '',
    this.trailingText = '%',
    this.resultText,
  });

  final String titleText;
  final String leadingText;
  final String trailingText;
  final String? resultText;
  final ({double? value, bool isEmpty}) valueCalculationResult;
  final Function onClear;
  final Function(int) onCalculate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(titleText),
            ListTile(
              leading: leadingText.isNotEmpty
                  ? Text(
                      leadingText,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    )
                  : null,
              trailing: Text(
                trailingText.isEmpty
                    ? ''
                    : valueCalculationResult.isEmpty == false
                        ? trailingText
                        : '%',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: _PercentageTextField(
                onChanged: (value) {
                  if (value.isEmpty) {
                    onClear();
                  } else {
                    onCalculate(
                      int.parse(
                        value,
                      ),
                    );
                  }
                },
              ),
            ),
            if (resultText != null && !valueCalculationResult.isEmpty)
              Text(
                resultText ?? '',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
          ],
        ),
      ),
    );
  }
}

class _PercentageTextField extends StatelessWidget {
  const _PercentageTextField({
    required this.onChanged,
  });

  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SizedBox(
        width: 45,
        child: TextField(
          textAlign: TextAlign.center,
          onChanged: onChanged,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      ),
    );
  }
}
