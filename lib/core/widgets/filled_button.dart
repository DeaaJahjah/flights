import 'package:flights/utils/r.dart';
import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isFilled = true,
  });

  final void Function()? onPressed;
  final String text;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        side: BorderSide(color: R.secondaryColor),
        backgroundColor: isFilled ? R.secondaryColor : R.primaryColor,
        // minimumSize: const Size(
        //   double.infinity,
        //   50,
        // ),
      ),
      child: Text(
        text,
        style: TextStyle(color: isFilled ? R.primaryColor : R.secondaryColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
