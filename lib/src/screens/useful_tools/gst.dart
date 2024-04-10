import 'package:finance/src/helper/number_range_helper.dart';
import 'package:finance/src/models/card_item.dart';
import 'package:finance/src/utils/constants.dart';
import 'package:finance/src/widgets/custom_slider.dart';
import 'package:finance/src/widgets/custom_text_field.dart';
import 'package:finance/src/widgets/info_card.dart';
import 'package:finance/src/widgets/spacer.dart';
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

  setDefault() {
    setState(() {
      dataMap[Constants.principalAmount] = 0;
      dataMap[Constants.totalInterest] = 0;
    });
  }

  calculate() {
    if (totalGstPercentage.text.isEmpty || amountController.text.isEmpty) {
      setDefault();
      return true;
    }
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
              FilteringTextInputFormatter.allow(
                RegExp(r'^\d+\.?\d{0,2}'),
              ),
              NumericRangeFormatter(
                min: Constants.minValue.toInt(),
                max: Constants.maxAvailablePrincipal.toInt(),
              ),
            ],
            textInputType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            controller: amountController,
            label: Constants.totalAmount,
            hint: Constants.enterTotalAmount,
          ),
          spacer(5, null),
          CustomSlider(
            value: _currentSliderValue,
            min: Constants.minValue,
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
          spacer(10, null),
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
            controller: totalGstPercentage,
            label: Constants.gstSlab,
            hint: Constants.enterGSTSlab,
          ),
          spacer(5, null),
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
