extension StringExtension on String {
  bool get validateWeightKg =>
      isNotEmpty &&
      RegExp(r'^((?![0])[0-9]{1,6}(\.\d{1,4})?$)|([0]{1}(\.\d{1,4}))')
          .hasMatch(this);
}
