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
        labelStyle: const TextStyle(
          color: Color(0xFF01579B),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Color(0xFF01579B),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(),
        ),
      ),
      cursorColor: const Color(0xFF01579B),
      enabled: enabled,
      keyboardType: textInputType,
      inputFormatters: inputFormatter,
      onChanged: (value) {
        handle(value);
      },
    );
  }
}
