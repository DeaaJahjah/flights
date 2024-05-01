import 'package:flights/core/widgets/filled_button.dart';
import 'package:flutter/material.dart';

class NextBackButtons extends StatelessWidget {
  const NextBackButtons({super.key, this.onBack, this.onNext});
  final void Function()? onNext;
  final void Function()? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: (onBack != null && onNext != null)
            ? MainAxisAlignment.spaceBetween
            : onNext == null
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
        children: [
          if (onBack != null)
            CustomFilledButton(
              onPressed: onBack,
              isFilled: false,
              text: 'رجوع',
            ),
          if (onNext != null)
            CustomFilledButton(
              onPressed: onNext,
              isFilled: true,
              text: 'التالي',
            ),
        ],
      ),
    );
  }
}
