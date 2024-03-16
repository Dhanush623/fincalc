import 'package:finance/src/helper/number_range_helper.dart';
import 'package:finance/src/models/card_item.dart';
import 'package:finance/src/utils/constants.dart';
import 'package:finance/src/widgets/custom_slider.dart';
import 'package:finance/src/widgets/info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class Loan extends StatefulWidget {
  const Loan({super.key});

  @override
  State<Loan> createState() => _LoanState();
}

class _LoanState extends State<Loan> {
  String selectedFrequency = 'Monthly';
  double _currentSliderValue = Constants.initAvailablePrincipal;
  double _rateOfInterestSliderValue = Constants.initRateOfInterest;
  double _totalYearSliderValue = Constants.initTotalYear;
  double _totalInterest = 0.0;
  double _totalPrincipal = 0.0;
  double _totalAmount = 0.0;
  double _monthlyEMI = 0.0;
  TextEditingController amountController = TextEditingController();
  TextEditingController rateOfInterestController = TextEditingController();
  TextEditingController totalYearController = TextEditingController();
  Map<String, double> dataMap = <String, double>{
    Constants.totalInterest: 0,
    Constants.totalAmount: 0,
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

  calculate() {
    double monthlyPayment = 0.0;
    double monthlyInterestRate =
        double.parse(rateOfInterestController.text) / 12 / 100;
    double totalPayments = double.parse(totalYearController.text) * 12;
    double numerator =
        monthlyInterestRate * math.pow(1 + monthlyInterestRate, totalPayments);
    double denominator = math.pow(1 + monthlyInterestRate, totalPayments) - 1;
    monthlyPayment =
        double.parse(amountController.text) * (numerator / denominator);
    double totInt = monthlyPayment * totalPayments;
    double totInte = totInt - double.parse(amountController.text);
    double principalPercentage = (totInt / (totInt + totInte)) * 100;
    double interestPercentage = (totInte / (totInt + totInte)) * 100;
    setState(() {
      _totalPrincipal = double.parse(amountController.text);
      _monthlyEMI = monthlyPayment;
      _totalAmount = totInt;
      _totalInterest = totInte;
      dataMap[Constants.totalInterest] = interestPercentage;
      dataMap[Constants.totalAmount] = principalPercentage;
    });
    debugPrint("_totalPrincipal $_totalPrincipal");
    debugPrint("_monthlyEMI $_monthlyEMI");
    debugPrint("_totalAmount $_totalAmount");
    debugPrint("_totalInterest $_totalInterest");
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
                Constants.loanTenure,
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
          InfoCard(
            list: [
              CardItem(
                key: Constants.principalAmount,
                value: _totalPrincipal,
              ),
              CardItem(
                key: Constants.totalInterest,
                value: _totalInterest,
              ),
              CardItem(
                key: Constants.monthlyEMI,
                value: _monthlyEMI,
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
