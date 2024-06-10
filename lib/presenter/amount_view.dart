import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salary_percentage/presenter/home_view.dart';
import 'package:salary_percentage/presenter/widgets/next_button_widget.dart';
import 'package:salary_percentage/presenter/widgets/toggle_item_widget.dart';
import 'package:salary_percentage/provider/amount_provider.dart';
import 'package:salary_percentage/utils/enums/calculation_type_enum.dart';

class AmountView extends HookConsumerWidget {
  AmountView({
    super.key,
    this.nextButton,
  });

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _percentageController = TextEditingController();

  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _percentageFocusNode = FocusNode();

  final Function? nextButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAmountToggled = useState(true);
    final isPercentageToggled = useState(false);
    final amount = ref.watch(amountProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'What do you want to calculate?',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ToggleButtons(
                    isSelected: [
                      isAmountToggled.value,
                      isPercentageToggled.value,
                    ],
                    fillColor: Theme.of(context).colorScheme.surfaceTint,
                    onPressed: (int index) {
                      isPercentageToggled.value = !isPercentageToggled.value;
                      isAmountToggled.value = !isAmountToggled.value;

                      if (isPercentageToggled.value) {
                        _percentageFocusNode.requestFocus();
                      }
                      if (isAmountToggled.value) {
                        _amountFocusNode.requestFocus();
                      }
                    },
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    children: <Widget>[
                      ToggleItemWidget(
                        text: 'Amount',
                        isPercentageToggled: isAmountToggled,
                      ),
                      ToggleItemWidget(
                        text: 'Percentage',
                        isPercentageToggled: isPercentageToggled,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AmountTextField.amount(
              enabled: isAmountToggled,
              onChanged: (value) => ref.read(amountNotifier).setAmount(value, CalculationType.amount),
              width: isAmountToggled.value ? null : MediaQuery.sizeOf(context).width * 0.5,
              focus: _amountFocusNode,
              controller: _amountController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),
            AmountTextField.percentage(
              enabled: isPercentageToggled,
              onChanged: (value) => ref.read(amountNotifier).setAmount(value, CalculationType.percentage),
              width: isPercentageToggled.value ? null : MediaQuery.sizeOf(context).width * 0.5,
              focus: _percentageFocusNode,
              controller: _percentageController,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const SizedBox(height: 20),
            NextButtonWidget(
              onPressed: (amount.value != 0.0)
                  ? nextButton == null
                      ? () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeView(),
                            ),
                          )
                      : () => nextButton!()
                  : null,
              accentColor: Theme.of(context).colorScheme.surfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class AmountTextField extends StatelessWidget {
  const AmountTextField({
    super.key,
    required this.controller,
    required this.enabled,
    required this.hintText,
    required this.icon,
    required this.onChanged,
    this.focus,
    this.inputFormatters,
    this.width,
    required,
  });

  final TextEditingController controller;
  final ValueNotifier<bool> enabled;
  final String hintText;
  final Icon icon;
  final Function(dynamic value) onChanged;
  final FocusNode? focus;
  final List<TextInputFormatter>? inputFormatters;
  final double? width;

  const AmountTextField.amount({
    super.key,
    required this.enabled,
    required this.onChanged,
    required this.controller,
    this.hintText = '100.0',
    this.icon = const Icon(Icons.attach_money),
    this.focus,
    this.inputFormatters,
    this.width,
  });

  const AmountTextField.percentage({
    super.key,
    required this.enabled,
    required this.onChanged,
    required this.controller,
    this.hintText = '20',
    this.icon = const Icon(Icons.percent),
    this.focus,
    this.inputFormatters,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.3),
          ),
          prefixIcon: icon,
          filled: enabled.value,
          fillColor: Theme.of(context).colorScheme.secondaryContainer,
          border: enabled.value
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                )
              : null,
        ),
        focusNode: focus,
        enabled: enabled.value,
        inputFormatters: inputFormatters,
        autocorrect: false,
        enableSuggestions: false,
        textInputAction: TextInputAction.done,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: onChanged,
      ),
    );
  }
}
