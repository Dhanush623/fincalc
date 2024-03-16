import 'package:finance/src/helper/number_range_helper.dart';
import 'package:finance/src/models/card_item.dart';
import 'package:finance/src/utils/constants.dart';
import 'package:finance/src/widgets/custom_slider.dart';
import 'package:finance/src/widgets/info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GST extends StatefulWidget {
  const GST({super.key});

  @override
  State<GST> createState() => _GSTState();
}

class _GSTState extends State<GST> {
  double _currentSliderValue = Constants.initAvailablePrincipal;
  double _totalYearSliderValue = Constants.initTotalYear;
  double _totalAmount = 0.0;
  double _totalGST = 0.0;
  TextEditingController amountController = TextEditingController();
  TextEditingController totalGstPercentage = TextEditingController();
  Map<String, double> dataMap = <String, double>{
    Constants.principalAmount: 0,
    Constants.totalInterest: 0,
  };
  String _gstValue = Constants.gstExclusive;

  @override
  void initState() {
    super.initState();
    setState(() {
      amountController.text =
          Constants.initAvailablePrincipal.toStringAsFixed(2);
      totalGstPercentage.text = Constants.initTotalYear.toStringAsFixed(0);
    });
    calculate();
  }

  calculate() {
    debugPrint("Amount  ${amountController.text}");
    debugPrint("Gst Percentage  ${totalGstPercentage.text}");
    debugPrint("Gst type  $_gstValue");
    if (_gstValue == Constants.gstExclusive) {
      double gst = (double.parse(amountController.text) *
              double.parse(totalGstPercentage.text)) /
          100;
      setState(() {
        _totalAmount = (double.parse(amountController.text)) + gst;
        _totalGST = gst;
      });
    } else {
      double gst = (double.parse(amountController.text) -
          (double.parse(amountController.text) *
              (100 / (100 + (double.parse(totalGstPercentage.text))))));
      setState(() {
        _totalAmount = (double.parse(amountController.text)) - gst;
        _totalGST = gst;
      });
    }
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
                Constants.totalAmount,
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
            children: [
              const Text(
                Constants.gstSlab,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .5,
                height: 50,
                child: TextField(
                  controller: totalGstPercentage,
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
                  totalGstPercentage.text = value.toStringAsFixed(0);
                },
              );
              calculate();
            },
          ),
          Row(
            children: [
              Radio(
                value: Constants.gstExclusive,
                groupValue: _gstValue,
                onChanged: (String? value) {
                  debugPrint("value $value");
                  debugPrint("_gstValue $_gstValue");
                  setState(() {
                    _gstValue = value.toString();
                  });
                  calculate();
                },
              ),
              const Text(Constants.gstExclusive),
            ],
          ),
          Row(
            children: [
              Radio(
                value: Constants.gstInclusive,
                groupValue: _gstValue,
                onChanged: (String? value) {
                  debugPrint("value $value");
                  debugPrint("_gstValue $_gstValue");
                  setState(() {
                    _gstValue = value.toString();
                  });
                  calculate();
                },
              ),
              const Text(Constants.gstInclusive),
            ],
          ),
          InfoCard(
            list: [
              CardItem(
                key: Constants.amount,
                value: _totalAmount,
              ),
              CardItem(
                key: Constants.gst,
                value: _totalGST,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
