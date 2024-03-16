import 'package:finance/src/helper/analytics_helper.dart';
import 'package:finance/src/models/sub_categories.dart';
import 'package:flutter/material.dart';

class Calculation extends StatefulWidget {
  const Calculation({super.key, required this.subCategories});
  final SubCategories subCategories;

  @override
  State<Calculation> createState() => _CalculationState();
}

class _CalculationState extends State<Calculation> {
  @override
  void initState() {
    super.initState();
    addScreenViewTracking("Calculation", widget.runtimeType.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text(widget.subCategories.name),
      ),
      body: SingleChildScrollView(
        child: widget.subCategories.widget,
      ),
    );
  }
}
