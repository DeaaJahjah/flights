import 'package:flights/utils/r.dart';
import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({super.key, required this.onPressed, required this.text});

  final void Function()? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: R.secondaryColor,
        // minimumSize: const Size(
        //   double.infinity,
        //   50,
        // ),
      ),
      child: Text(
        text,
        style: TextStyle(color: R.primaryColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
