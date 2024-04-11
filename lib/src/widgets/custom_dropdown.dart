import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.selectedValue,
    required this.dropdownList,
    required this.listKey,
    required this.listValue,
    required this.onChanged,
  });
  final String hintText;
  final String labelText;
  final String? selectedValue;
  final List<Map<String, dynamic>> dropdownList;
  final String listKey;
  final String listValue;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            25.0,
          ),
        ),
        labelStyle: const TextStyle(
          color: Color(0xFF01579B),
        ),
        hintText: hintText,
        labelText: labelText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Color(0xFF01579B),
          ),
        ),
      ),
      value: selectedValue,
      onChanged: (String? newValue) {
        onChanged(newValue);
      },
      items: dropdownList.map((Map<String, dynamic> item) {
        return DropdownMenuItem<String>(
          value: item[listKey].toString(),
          child: Text(item[listValue].toString()),
        );
      }).toList(),
    );
  }
}
