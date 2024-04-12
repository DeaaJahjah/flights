//show snackbar
import 'package:flutter/material.dart';

void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message, style: Theme.of(context).textTheme.bodySmall),
    backgroundColor: Colors.green[400],
  ));
}

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white)),
    backgroundColor: Colors.red[400],
  ));
}
