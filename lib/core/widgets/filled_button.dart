import 'package:flights/utils/r.dart';
import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({super.key, required this.onPressed, required this.text});

  final void Function()? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        // style: FilledButton.styleFrom(
        //   backgroundColor: R.secondaryColor,
        //   minimumSize: const Size(
        //     double.infinity,
        //     50,
        //   ),
        // shape: RoundedRectangleBorder(

        // ),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: R.secondaryColor),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(color: R.primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
