import 'package:finance/src/helper/number_range_helper.dart';
import 'package:finance/src/models/card_item.dart';
import 'package:finance/src/utils/constants.dart';
import 'package:finance/src/widgets/custom_slider.dart';
import 'package:finance/src/widgets/custom_text_field.dart';
import 'package:finance/src/widgets/info_card.dart';
import 'package:finance/src/widgets/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class SWPInvestment extends StatefulWidget {
  const SWPInvestment({super.key});

  @override
  State<SWPInvestment> createState() => _SWPInvestmentState();
}

class _SWPInvestmentState extends State<SWPInvestment> {
  String selectedFrequency = 'Monthly';
  double _currentSliderValue = Constants.ppfInitAvailablePrincipal;
  double _withdrawnSliderValue = Constants.withdrawnAmountLimit;
  double _totalYearSliderValue = Constants.initTotalYear;
  double _rateOfInterestSliderValue = Constants.sipRateOfInterest;
  double _totalEstAmount = 0.0;
  double _totalPrincipal = 0.0;
  double _totalAmount = 0.0;
  double _withdrawn = 0.0;
  TextEditingController amountController = TextEditingController();
  TextEditingController withdrawnAmountController = TextEditingController();
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
      withdrawnAmountController.text =
          Constants.withdrawnAmountLimit.toStringAsFixed(2);
      rateOfInterestController.text =
          Constants.sipRateOfInterest.toStringAsFixed(1);
      totalYearController.text = Constants.initTotalYear.toStringAsFixed(0);
    });
    calculate();
  }

  setDefault() {
    setState(() {
      dataMap[Constants.investmentAmount] = 0;
      dataMap[Constants.estAmount] = 0;
    });
  }

  calculate() {
    if (rateOfInterestController.text.isEmpty ||
        withdrawnAmountController.text.isEmpty ||
        totalYearController.text.isEmpty ||
        amountController.text.isEmpty) {
      setDefault();
      return true;
    }
    double amount = double.parse(amountController.text);
    double duration = double.parse(totalYearController.text);
    double rateOfReturn = double.parse(rateOfInterestController.text);
    double withdraw = double.parse(withdrawnAmountController.text);

    maturityAmount = ((amount * math.pow((1 + rateOfReturn / 100), duration)) -
        (withdraw *
            (math.pow((1 + (math.pow((1 + rateOfReturn / 100), (1 / 12)) - 1)),
                    (duration * 12)) -
                1) /
            (math.pow((1 + rateOfReturn / 100), (1 / 12)) - 1)));
    double withdrawn = duration * 12 * withdraw;
    setState(() {
      _totalAmount = maturityAmount;
      _withdrawn = withdrawn;
      _totalEstAmount = maturityAmount -
          (double.parse(amountController.text) *
              double.parse(totalYearController.text) *
              12);

      _totalPrincipal = double.parse(amountController.text) *
          double.parse(totalYearController.text) *
          12;
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
                min: Constants.ppfMinAvailablePrincipal.toInt(),
                max: Constants.maxAvailablePrincipal.toInt(),
              ),
            ],
            textInputType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            controller: amountController,
            label: Constants.monthlyAmount,
            hint: Constants.enterMonthlyAmount,
          ),
          CustomSlider(
            value: _currentSliderValue,
            min: Constants.ppfMinAvailablePrincipal,
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
                  _withdrawnSliderValue = 0.0;
                });
              }
              if (double.tryParse(value) != null) {
                setState(() {
                  _withdrawnSliderValue = double.parse(value);
                });
              }
              calculate();
            },
            inputFormatter: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              NumericRangeFormatter(
                min: Constants.ppfMinAvailablePrincipal.toInt(),
                max: Constants.maxAvailablePrincipal.toInt(),
              ),
            ],
            textInputType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            controller: withdrawnAmountController,
            label: Constants.withdrawnAmount,
            hint: Constants.enterWithdrawnAmount,
          ),
          CustomSlider(
            value: _withdrawnSliderValue,
            min: Constants.ppfMinAvailablePrincipal,
            max: Constants.maxAvailablePrincipal,
            divisions: Constants.amountSliderDivision,
            label: _withdrawnSliderValue.round().toString(),
            handle: (double value) {
              setState(() {
                _withdrawnSliderValue = double.parse(value.toStringAsFixed(2));
                withdrawnAmountController.text = value.toStringAsFixed(2);
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
                setState(() {
                  _rateOfInterestSliderValue = double.parse(value);
                });
              }
              calculate();
            },
            inputFormatter: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
              NumericRangeFormatter(
                min: Constants.minInitRateOfInterest.toInt(),
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
            min: Constants.minInitRateOfInterest,
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
                min: Constants.minInitTotalYear.toInt(),
                max: Constants.ppfMaxTotalYear.toInt(),
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
            min: Constants.minInitTotalYear,
            max: Constants.ppfMaxTotalYear,
            divisions: Constants.totalYearDivisionInvestment,
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
          if (_currentSliderValue != 0.0)
            InfoCard(
              list: [
                CardItem(
                  key: Constants.investmentAmount,
                  value: double.parse(amountController.text),
                ),
                CardItem(
                  key: Constants.withdrawnAmount,
                  value: _withdrawn,
                ),
                CardItem(
                  key: Constants.totalAmount,
                  value: _totalAmount,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
