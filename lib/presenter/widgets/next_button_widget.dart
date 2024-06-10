import 'package:flutter/material.dart';

class NextButtonWidget extends StatelessWidget {
  const NextButtonWidget({
    super.key,
    required this.onPressed,
    this.text = 'Calculate',
    this.backgroundColor,
    this.accentColor,
  });

  final String text;
  final Function()? onPressed;
  final Color? backgroundColor;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.tertiary,
        textStyle: TextStyle(
          color: accentColor ?? Theme.of(context).colorScheme.inversePrimary,
        ),
        disabledBackgroundColor: Theme.of(context).colorScheme.outlineVariant,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: accentColor ??
                      Theme.of(context).colorScheme.inversePrimary,
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(
              Icons.arrow_forward,
              color:
                  accentColor ?? Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ],
      ),
    );
  }
}
