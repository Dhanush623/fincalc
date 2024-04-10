import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextInput extends StatelessWidget {
  const CustomTextInput({
    super.key,
    required this.controller,
    required this.inputFormatter,
    required this.label,
    required this.hint,
    required this.textInputType,
    required this.handle,
    this.enabled,
  });
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatter;
  final TextInputType? textInputType;
  final Function handle;
  final String label;
  final String hint;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        label: Text(label),
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(),
        ),
      ),
      enabled: enabled,
      keyboardType: textInputType,
      inputFormatters: inputFormatter,
      onChanged: (value) {
        handle(value);
      },
    );
  }
}
