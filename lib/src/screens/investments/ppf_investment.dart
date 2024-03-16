import 'package:finance/src/helper/number_range_helper.dart';
import 'package:finance/src/models/card_item.dart';
import 'package:finance/src/utils/constants.dart';
import 'package:finance/src/widgets/amount_chart.dart';
import 'package:finance/src/widgets/custom_slider.dart';
import 'package:finance/src/widgets/info_card.dart';
import 'package:finance/src/widgets/spacing_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class PPFInvestment extends StatefulWidget {
  const PPFInvestment({super.key});

  @override
  State<PPFInvestment> createState() => _PPFInvestmentState();
}

class _PPFInvestmentState extends State<PPFInvestment> {
  String selectedFrequency = 'Monthly';
  double _currentSliderValue = Constants.initAvailablePrincipal;
  double _totalYearSliderValue = Constants.initTotalYear;
  double _totalEstAmount = 0.0;
  double _totalPrincipal = 0.0;
  double _totalAmount = 0.0;
  TextEditingController amountController = TextEditingController();
  TextEditingController rateOfInterestController = TextEditingController();
  TextEditingController totalYearController = TextEditingController();
  Map<String, double> dataMap = <String, double>{
    Constants.investmentAmount: 0,
    Constants.estAmount: 0,
  };
  double maturityAmount = 0.0;
  @override
  void initState() {
    super.initState();
    setState(() {
      amountController.text =
          Constants.ppfInitAvailablePrincipal.toStringAsFixed(2);
      rateOfInterestController.text =
          Constants.ppfInitRateOfInterest.toStringAsFixed(1);
      totalYearController.text = Constants.ppfInitTotalYear.toStringAsFixed(0);
    });
    calculate();
  }

  calculate() {
    maturityAmount = (((double.parse(amountController.text) *
                (math.pow(1 + double.parse(rateOfInterestController.text) / 100,
                        double.parse(totalYearController.text)) -
                    1)) /
            (double.parse(rateOfInterestController.text) / 100)) *
        (1 + double.parse(rateOfInterestController.text) / 100));
    setState(() {
      _totalAmount = maturityAmount;
      _totalEstAmount = maturityAmount -
          (double.parse(amountController.text) *
              double.parse(totalYearController.text));

      _totalPrincipal = double.parse(amountController.text) *
          double.parse(totalYearController.text);
      dataMap[Constants.investmentAmount] =
          (_totalPrincipal / (_totalPrincipal + _totalEstAmount)) * 100;
      dataMap[Constants.estAmount] =
          (_totalEstAmount / (_totalPrincipal + _totalEstAmount)) * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                Constants.yearlyAmount,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .5,
                height: 50,
                child: TextField(
                  controller: amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                    NumericRangeFormatter(
                      min: Constants.ppfInitAvailablePrincipal.toInt(),
                      max: Constants.maxAvailablePrincipal.toInt(),
                    ),
                  ],
                  onChanged: (value) {
                    if (value.isEmpty) return;
                    if (double.tryParse(value) != null) {
                      setState(() {
                        _currentSliderValue = double.parse(value);
                      });
                    }
                    calculate();
                  },
                ),
              ),
            ],
          ),
          CustomSlider(
            value: _currentSliderValue,
            min: Constants.ppfInitAvailablePrincipal,
            max: Constants.maxAvailablePrincipal,
            divisions: Constants.amountSliderDivision,
            label: _currentSliderValue.round().toString(),
            handle: (double value) {
              setState(() {
                _currentSliderValue = double.parse(value.toStringAsFixed(2));
                amountController.text = value.toStringAsFixed(2);
              });
              calculate();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                Constants.rateOfInterest,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .5,
                height: 50,
                child: TextField(
                  controller: rateOfInterestController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  enabled: false,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,1}')),
                    NumericRangeFormatter(
                      min: Constants.minRateOfInterest.toInt(),
                      max: Constants.maxRateOfInterest.toInt(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                Constants.timePeriod,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .5,
                height: 50,
                child: TextField(
                  controller: totalYearController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    NumericRangeFormatter(
                      min: Constants.minTotalYear.toInt(),
                      max: Constants.maxTotalYear.toInt(),
                    ),
                  ],
                  onChanged: (value) {
                    if (value.isEmpty) return;
                    if (double.tryParse(value) != null) {
                      setState(
                        () {
                          _totalYearSliderValue = double.parse(value);
                        },
                      );
                    }
                    calculate();
                  },
                ),
              ),
            ],
          ),
          CustomSlider(
            value: _totalYearSliderValue,
            min: Constants.ppfInitTotalYear,
            max: Constants.ppfMaxTotalYear,
            divisions: Constants.totalYearDivision,
            label: _totalYearSliderValue.round().toString(),
            handle: (double value) {
              setState(
                () {
                  _totalYearSliderValue =
                      double.parse(value.toStringAsFixed(0));
                  totalYearController.text = value.toStringAsFixed(0);
                },
              );
              calculate();
            },
          ),
          InfoCard(
            list: [
              CardItem(
                key: Constants.investmentAmount,
                value: _totalPrincipal,
              ),
              CardItem(
                key: Constants.returnAmount,
                value: _totalEstAmount,
              ),
              CardItem(
                key: Constants.totalAmount,
                value: _totalAmount,
              ),
            ],
          ),
          const SpacingCard(),
          AmountChart(
            dataMap: dataMap,
          ),
        ],
      ),
    );
  }
}
