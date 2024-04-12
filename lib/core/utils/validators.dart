String? emptyValidator(String? value) {
  if (value!.isEmpty) {
    return 'هذا الحقل مطلوب';
  } else {
    return null;
  }
}
