import 'package:finance/src/helper/frequency_helper.dart';
import 'package:finance/src/helper/number_range_helper.dart';
import 'package:finance/src/models/card_item.dart';
import 'package:finance/src/utils/constants.dart';
import 'package:finance/src/widgets/amount_chart.dart';
import 'package:finance/src/widgets/custom_dropdown.dart';
import 'package:finance/src/widgets/custom_slider.dart';
import 'package:finance/src/widgets/custom_text_field.dart';
import 'package:finance/src/widgets/info_card.dart';
import 'package:finance/src/widgets/spacer.dart';
import 'package:finance/src/widgets/spacing_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class CompoundInterest extends StatefulWidget {
  const CompoundInterest({super.key});

  @override
  State<CompoundInterest> createState() => _CompoundInterestState();
}

class _CompoundInterestState extends State<CompoundInterest> {
  String selectedFrequency = 'Monthly';
  double _currentSliderValue = Constants.initAvailablePrincipal;
  double _rateOfInterestSliderValue = Constants.initRateOfInterest;
  double _totalYearSliderValue = Constants.initTotalYear;
  double _totalInterest = 0.0;
  TextEditingController amountController = TextEditingController();
  TextEditingController rateOfInterestController = TextEditingController();
  TextEditingController totalYearController = TextEditingController();
  Map<String, double> dataMap = <String, double>{
    Constants.principalAmount: 0,
    Constants.totalInterest: 0,
  };

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

  setDefault() {
    setState(() {
      dataMap[Constants.principalAmount] = 0;
      dataMap[Constants.totalInterest] = 0;
      _totalInterest = 0.0;
    });
  }

  calculate() {
    if (rateOfInterestController.text.isEmpty ||
        totalYearController.text.isEmpty ||
        amountController.text.isEmpty) {
      setDefault();
      return true;
    }
    int frequency = findValueByKey(Constants.popList, selectedFrequency);
    double principalAmount = double.parse(amountController.text) *
        frequency *
        int.parse(totalYearController.text);
    double finalAmount = double.parse(amountController.text) *
        math.pow(
            1 + (double.parse(rateOfInterestController.text) / 100) / frequency,
            (frequency * double.parse(totalYearController.text)));
    double principalPercentage =
        (principalAmount / (principalAmount + finalAmount)) * 100;
    double interestPercentage =
        (finalAmount / (principalAmount + finalAmount)) * 100;
    setState(() {
      dataMap[Constants.totalInterest] = interestPercentage;
      dataMap[Constants.principalAmount] = principalPercentage;
      _totalInterest = finalAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextInput(
            handle: (value) {
              if (value.isEmpty) {
                setState(() {
                  _currentSliderValue = 0.0;
                });
              }
              if (double.tryParse(value) != null) {
                setState(() {
                  _currentSliderValue = double.parse(value);
                });
              }
              calculate();
            },
            inputFormatter: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              NumericRangeFormatter(
                min: Constants.minAvailablePrincipal.toInt(),
                max: Constants.maxAvailablePrincipal.toInt(),
              ),
            ],
            textInputType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            controller: amountController,
            label: Constants.principalAmount,
            hint: Constants.enterPrincipalAmount,
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
          spacer(5, null),
          CustomTextInput(
            handle: (value) {
              if (value.isEmpty) {
                setState(() {
                  _rateOfInterestSliderValue = 0.0;
                });
              }
              if (double.tryParse(value) != null) {
                setState(
                  () {
                    _rateOfInterestSliderValue = double.parse(value);
                  },
                );
              }
              calculate();
            },
            inputFormatter: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
              NumericRangeFormatter(
                min: Constants.minRateOfInterest.toInt(),
                max: Constants.maxRateOfInterest.toInt(),
              ),
            ],
            textInputType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            controller: rateOfInterestController,
            label: Constants.rateOfInterest,
            hint: Constants.enterRateOfInterest,
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
          spacer(5, null),
          CustomTextInput(
            handle: (value) {
              if (value.isEmpty) {
                setState(() {
                  _totalYearSliderValue = 0.0;
                });
              }
              if (double.tryParse(value) != null) {
                setState(
                  () {
                    _totalYearSliderValue = double.parse(value);
                  },
                );
              }
              calculate();
            },
            inputFormatter: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              NumericRangeFormatter(
                min: Constants.minTotalYear.toInt(),
                max: Constants.maxTotalYear.toInt(),
              ),
            ],
            textInputType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            controller: totalYearController,
            label: Constants.timePeriod,
            hint: Constants.enterTimePeriod,
          ),
          CustomSlider(
            value: _totalYearSliderValue,
            min: Constants.minTotalYear,
            max: Constants.maxTotalYear,
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
          spacer(5, null),
          CustomDropdown(
            selectedValue: selectedFrequency,
            onChanged: (String? newValue) {
              setState(() {
                selectedFrequency = newValue!;
              });
              calculate();
            },
            listKey: "key",
            listValue: "key",
            dropdownList: Constants.list,
            hintText: Constants.selectCompoundingFrequency,
            labelText: Constants.compoundingFrequency,
          ),
          spacer(5, null),
          if (_currentSliderValue != 0.0 &&
              _rateOfInterestSliderValue != 0.0 &&
              _totalYearSliderValue != 0.0)
            Column(
              children: [
                InfoCard(
                  list: [
                    CardItem(
                      key: Constants.principalAmount,
                      value: double.parse(amountController.text),
                    ),
                    CardItem(
                      key: Constants.totalInterest,
                      value:
                          _totalInterest - double.parse(amountController.text),
                    ),
                    CardItem(
                      key: Constants.totalAmount,
                      value: _totalInterest,
                    ),
                  ],
                ),
                const SpacingCard(),
                AmountChart(
                  dataMap: dataMap,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
