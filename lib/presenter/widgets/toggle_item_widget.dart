import 'package:flutter/material.dart';

class ToggleItemWidget extends StatelessWidget {
  const ToggleItemWidget({
    super.key,
    required ValueNotifier<bool> isPercentageToggled,
    required String text,
    this.textColor,
  })  : _isPercentageToggled = isPercentageToggled,
        _text = text;

  final ValueNotifier<bool> _isPercentageToggled;
  final String _text;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        _text,
        style: _isPercentageToggled.value
            ? Theme.of(context).textTheme.titleLarge?.copyWith(
                  color:
                      textColor ?? Theme.of(context).colorScheme.surfaceVariant,
                  fontWeight: FontWeight.bold,
                )
            : Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textColor ??
                      Theme.of(context)
                          .colorScheme
                          .surfaceTint
                          .withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                ),
      ),
    );
  }
}
