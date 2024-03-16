import 'package:flutter/services.dart';

class NumericRangeFormatter extends TextInputFormatter {
  final int min;
  final int max;

  NumericRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    try {
      final int parsedValue = int.parse(newValue.text);

      if (parsedValue < min) {
        return TextEditingValue(
          text: min.toString(),
          selection: TextSelection.fromPosition(
            TextPosition(offset: min.toString().length),
          ),
        );
      } else if (parsedValue > max) {
        return TextEditingValue(
          text: max.toString(),
          selection: TextSelection.fromPosition(
            TextPosition(offset: max.toString().length),
          ),
        );
      }
    } catch (e) {
      // Handle non-integer input
    }

    return newValue;
  }
}
