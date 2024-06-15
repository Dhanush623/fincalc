import 'package:finance/src/models/category.dart';
import 'package:finance/src/models/sub_categories.dart';
import 'package:finance/src/screens/deposits/fixed_deposits.dart';
import 'package:finance/src/screens/investments/lumpsum_investment.dart';
import 'package:finance/src/screens/investments/ppf_investment.dart';
import 'package:finance/src/screens/deposits/recurring_deposits.dart';
import 'package:finance/src/screens/investments/sip_investment.dart';
import 'package:finance/src/screens/investments/swp_investment.dart';
import 'package:finance/src/screens/loans/loan.dart';
import 'package:finance/src/screens/useful_tools/compound_interest.dart';
import 'package:finance/src/screens/useful_tools/gst.dart';
import 'package:finance/src/screens/useful_tools/simple_interest.dart';
import 'package:flutter/material.dart';

class Constants {
  static const String finCalc = "FinCalc";
  static const String settings = "Settings";
  static const String dashboard = "Dashboard";
  static const String screen = "Screen";
  static const String button = "Button";
  static const String darkTheme = "Dark Theme";
  static const String notifications = "Notifications";
  static const String cagr = "CAGR";
  static const String emi = "EMI";
  static const String carBikeLoanEMI = "Car & Bike Loan EMI";
  static const String homeLoanEMI = "Home Loan EMI";
  static const String gst = "GST";
  static const String gstSlab = "GST Slab";
  static const String enterGSTSlab = "Enter GST Slab";
  static const String gstExclusive = "GST Exclusive";
  static const String gstInclusive = "GST Inclusive";
  static const String ppf = "PPF";
  static const String mf = "Mutual Fund";
  static const String lumpsum = "Lumpsum";
  static const String sip = "SIP";
  static const String stp = "STP";
  static const String swp = "SWP";
  static const String fd = "Fixed Deposit";
  static const String recurringDeposit = "Recurring Deposit";
  static const String compoundInterest = "Compound Interest";
  static const String simpleInterest = "Simple Interest";
  static const String usefulTools = "Useful Tools";
  static const String loan = "Loan";
  static const String deposit = "Deposit";
  static const String investment = "Investment";
  static const String investmentAmount = "Investment Amount";
  static const String enterInvestmentAmount = "Enter Investment Amount";
  static const String principalAmount = "Principal Amount";
  static const String enterPrincipalAmount = "Enter Principal Amount";
  static const String yearlyAmount = "Yearly Amount";
  static const String enterYearlyAmount = "Enter Yearly Amount";
  static const String rateOfInterest = "Rate of Interest(%p.a)";
  static const String enterRateOfInterest = "Enter Rate of Interest(%p.a)";
  static const String timePeriod = "Time Period (yr)";
  static const String enterTimePeriod = "Enter Time Period in years";
  static const String totalInterest = "Total Interest";
  static const String totalAmount = "Total Amount";
  static const String enterTotalAmount = "Enter Total Amount";
  static const String withdrawnAmount = "Withdrawn Amount";
  static const String enterWithdrawnAmount = "Enter Withdrawn Amount";
  static const String estAmount = "Estimation Amount";
  static const String amount = "Amount";
  static const String returnAmount = "Return Amount";
  static const String compoundingFrequency = "Compounding Frequency";
  static const String selectCompoundingFrequency =
      "Select Compounding Frequency";
  static const String loanTenure = "Loan Tenure (yr)";
  static const String enterLoanTenure = "Enter Loan Tenure Year";
  static const String monthlyEMI = "Monthly EMI";
  static const String monthlyAmount = "Monthly Amount";
  static const String enterMonthlyAmount = "Enter Monthly Amount";
  static const String selectedTheme = "themeData";
  static const String copyrightLabel = "Copyright © ";
  static const String firebaseEventKey = "page";
  static const String firebasePageEventKey = "opened";
  static const String firebaseScreenViewKey = "screen_view";
  static const String channelId = "default";
  static const String channelName = "default";
  static const double minValue = 0;
  static const double maxAvailablePrincipal = 10000000;
  static const double minAvailablePrincipal = 0;
  static const double initAvailablePrincipal = 100000;
  static const double ppfInitAvailablePrincipal = 1000;
  static const double ppfMinAvailablePrincipal = 0;
  static const double withdrawnAmountLimit = 10000;
  static const double minInitRateOfInterest = 1;
  static const double initRateOfInterest = 6;
  static const double sipRateOfInterest = 12;
  static const double ppfInitRateOfInterest = 7.1;
  static const double maxRateOfInterest = 50;
  static const double minRateOfInterest = 1;
  static const double initTotalYear = 5;
  static const double minInitTotalYear = 1;
  static const double ppfInitTotalYear = 15;
  static const double maxTotalYear = 30;
  static const double maxTotalYearTen = 10;
  static const double ppfMaxTotalYear = 50;
  static const double minTotalYear = 1;
  static const int amountSliderDivision = 10000;
  static const int totalYearDivision = 29;
  static const int totalYearDivisionInvestment = 49;
  static const String darwinNotificationCategoryText = 'textCategory';
  static const String darwinNotificationCategoryPlain = 'plainCategory';
  static const String navigationActionId = 'id_3';
  static const String platform = 'platform';
  static const String adUnitId = 'ca-app-pub-8923335269347910/3249792139';
  static const String termsConditions = "Terms & Conditions";
  static const String fincalcPrivacyPolicy =
      "https://dhanush623.github.io/fincalc_privacy_policy.html";
  static List<Category> categoryList = [
    Category(
      id: 1,
      name: usefulTools,
      subCategories: [
        SubCategories(
          id: 101,
          name: simpleInterest,
          widget: const SimpleInterest(),
        ),
        SubCategories(
          id: 102,
          name: compoundInterest,
          widget: const CompoundInterest(),
        ),
        SubCategories(
          id: 103,
          name: gst,
          widget: const GST(),
        ),
        // SubCategories(id: 104, name: cagr, widget: const SimpleInterest()),
      ],
    ),
    Category(
      id: 2,
      name: loan,
      subCategories: [
        SubCategories(
          id: 201,
          name: homeLoanEMI,
          widget: const Loan(),
        ),
        SubCategories(
          id: 202,
          name: carBikeLoanEMI,
          widget: const Loan(),
        ),
        SubCategories(
          id: 203,
          name: emi,
          widget: const Loan(),
        ),
      ],
    ),
    Category(
      id: 3,
      name: deposit,
      subCategories: [
        SubCategories(
          id: 301,
          name: recurringDeposit,
          widget: const RecurringDeposit(),
        ),
        SubCategories(
          id: 302,
          name: fd,
          widget: const FixedDeposit(),
        ),
      ],
    ),
    Category(
      id: 4,
      name: investment,
      subCategories: [
        SubCategories(
          id: 401,
          name: sip,
          widget: const SipInvestment(),
        ),
        SubCategories(
          id: 402,
          name: lumpsum,
          widget: const LumpsumInvestment(),
        ),
        SubCategories(
          id: 403,
          name: swp,
          widget: const SWPInvestment(),
        ),
        SubCategories(
          id: 404,
          name: ppf,
          widget: const PPFInvestment(),
        ),
      ],
    ),
  ];
  static List<Color> colorList = <Color>[
    Colors.greenAccent,
    Colors.blueAccent,
  ];
  static List<Map<String, dynamic>> list = <Map<String, dynamic>>[
    {'key': 'Monthly', 'value': 1},
    {'key': 'Quarterly', 'value': 4},
    {'key': 'Half Yearly', 'value': 6},
    {'key': 'Yearly', 'value': 12}
  ];
  static List<Map<String, dynamic>> popList = <Map<String, dynamic>>[
    {'key': 'Monthly', 'value': 12},
    {'key': 'Quarterly', 'value': 4},
    {'key': 'Half Yearly', 'value': 2},
    {'key': 'Yearly', 'value': 1}
  ];
}
