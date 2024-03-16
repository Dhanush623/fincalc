import 'package:finance/src/helper/frequency_helper.dart';
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

class RecurringDeposit extends StatefulWidget {
  const RecurringDeposit({super.key});

  @override
  State<RecurringDeposit> createState() => _RecurringDepositState();
}

class _RecurringDepositState extends State<RecurringDeposit> {
  String selectedFrequency = 'Monthly';
  double _currentSliderValue = Constants.initAvailablePrincipal;
  double _rateOfInterestSliderValue = Constants.initRateOfInterest;
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
          Constants.initAvailablePrincipal.toStringAsFixed(2);
      rateOfInterestController.text =
          Constants.initRateOfInterest.toStringAsFixed(1);
      totalYearController.text = Constants.initTotalYear.toStringAsFixed(0);
    });
    calculate();
  }

  calculate() {
    int frequency = findValueByKey(Constants.list, selectedFrequency);

    double monthlyInterestRate =
        double.parse(rateOfInterestController.text) / 100 / frequency;
    int totalPayments = int.parse(totalYearController.text) * frequency;
    num power = math.pow(1 + monthlyInterestRate, totalPayments);
    // double numerator = (double.parse(amountController.text) * power) -
    //     double.parse(amountController.text);
    double numerator = double.parse(amountController.text) *
        ((power - 1) / monthlyInterestRate);
    double denominator = monthlyInterestRate;

    // maturityAmount = numerator / denominator;
    maturityAmount = numerator * (1 + monthlyInterestRate);

    debugPrint("frequency $frequency");
    debugPrint("totalPayments $totalPayments");
    debugPrint("power $power");
    debugPrint("numerator $numerator");
    debugPrint("denominator $denominator");
    debugPrint("maturityAmount $maturityAmount");
    setState(() {
      _totalAmount = maturityAmount;
      _totalEstAmount = maturityAmount -
          (totalPayments * double.parse(amountController.text));
      _totalPrincipal =
          totalPayments.toDouble() * double.parse(amountController.text);
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
                Constants.principalAmount,
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
                      min: Constants.minAvailablePrincipal.toInt(),
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
            min: Constants.minAvailablePrincipal,
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
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,1}')),
                    NumericRangeFormatter(
                      min: Constants.minRateOfInterest.toInt(),
                      max: Constants.maxRateOfInterest.toInt(),
                    ),
                  ],
                  onChanged: (value) {
                    if (value.isEmpty) return;
                    if (double.tryParse(value) != null) {
                      setState(
                        () {
                          _rateOfInterestSliderValue = double.parse(value);
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
            value: _rateOfInterestSliderValue,
            min: Constants.minRateOfInterest,
            max: Constants.maxRateOfInterest,
            label: _rateOfInterestSliderValue.round().toString(),
            handle: (double value) {
              setState(
                () {
                  _rateOfInterestSliderValue =
                      double.parse(value.toStringAsFixed(1));
                  rateOfInterestController.text = value.toStringAsFixed(1);
                },
              );
              calculate();
            },
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
                      max: Constants.maxTotalYearTen.toInt(),
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
            min: Constants.minTotalYear,
            max: Constants.maxTotalYearTen,
            divisions: Constants.maxTotalYearTen.toInt() - 1,
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
