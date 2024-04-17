import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final Icon prefixIcon;
  final Color mainColor;
  final Color secondaryColor;
  final bool isTextObscure;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final bool readOnly;
  final bool digitsOnly;
  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.prefixIcon,
    required this.mainColor,
    required this.secondaryColor,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.onTap,
    this.readOnly = false,
    this.isTextObscure = false,
    this.digitsOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onTap: onTap,
      readOnly: readOnly,
      // id(digitsOnly)
      validator: validator,
      inputFormatters: !digitsOnly ? null : [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: labelText,
        labelStyle: TextStyle(color: secondaryColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: secondaryColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: mainColor),
        ),
      ),
      cursorColor: mainColor,
      obscureText: isTextObscure,
      style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
    );
  }
}
