import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomSlider extends StatelessWidget {
  CustomSlider(
      {super.key,
      required this.value,
      required this.min,
      required this.max,
      this.divisions,
      required this.label,
      required this.handle});
  final double value;
  final double min;
  final double max;
  int? divisions;
  final String label;
  final Function handle;

  @override
  Widget build(BuildContext context) {
    return Slider(
        activeColor: const Color(0xFF01579B),
        value: value > min ? value : min,
        min: min,
        max: max,
        divisions: divisions,
        label: label,
        onChanged: (double value) {
          handle(value);
        });
  }
}
