import 'package:finance/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class AmountChart extends StatelessWidget {
  const AmountChart({super.key, required this.dataMap});
  final Map<String, double> dataMap;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: dataMap,
      chartType: ChartType.ring,
      baseChartColor: Colors.grey[50]!.withOpacity(0.15),
      colorList: Constants.colorList,
      chartValuesOptions: const ChartValuesOptions(
        showChartValuesInPercentage: true,
      ),
      totalValue: 100,
    );
  }
}
