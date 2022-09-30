// ignore_for_file: use_build_context_synchronously, unused_local_variable, unused_element

// THIS IS, BY MY ASSESSMENT, THE HEART OF THE APP
// THE LRS IS GENERATED HERE

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

List<String> interestRateOptions = ['Fixed', 'Reducing Balance'];
var referralDataMap = {};

final referralName = TextEditingController();
final referralMobile = TextEditingController();
final referralEmail = TextEditingController();
final loanAmountGiven = TextEditingController();
final loanYearlyRateGiven = TextEditingController();
final loanPeriodYearsGiven = TextEditingController();
final oldPassword = TextEditingController();
final newPassword = TextEditingController();

class HomeAgent extends StatefulWidget {
  const HomeAgent(
      {super.key,
      required this.agentId,
      required this.clientId,
      required this.fetchedRefCount});
  final String agentId;
  final String clientId;
  final int fetchedRefCount;
  @override
  State<HomeAgent> createState() => _HomeAgent();
}

class _HomeAgent extends State<HomeAgent> {
  // THIS CLASS CARRIES FOUR WIDGETS
  String dropdownValue =
      interestRateOptions[1]; // SETTING A DEFAULT DROP DOWN VALUE
  var _currentIndex = 0; // USED TO SWITCH BETWEEN THE FOUR WIDGET
  late int displayedReferralCount = widget.fetchedRefCount;

  Widget _currentWidget = Container();
  final _formKey = GlobalKey<FormState>();

  // CALCULATE SCREEN, WHERE THE LOAN MATH HAPPENS
  // THEN THE INFO, A CSV FILE, DISPLAYS ON A WIDGET
  Widget _calculateScreen() {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              width: 250,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                controller: loanAmountGiven,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'LOAN AMOUNT',
                    hintText: 'in KES'),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: 250,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                controller: loanYearlyRateGiven,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'RATE',
                    hintText: 'e.g. 12 to mean 12%'),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: 250,
              child: DropdownButtonFormField<String>(
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                value: dropdownValue,
                items: interestRateOptions.map((String newValue) {
                  return DropdownMenuItem<String>(
                    value: newValue,
                    child: Text(newValue),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                onSaved: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: 250,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                controller: loanPeriodYearsGiven,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'PERIOD',
                    hintText: 'in YEARS (1, 2, 5, etc.)'),
              ),
            ),
            const SizedBox(height: 25),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    generateCSV(dropdownValue);
                  }
                },
                child: const Text(
                  'GENERATE LRS',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // REFER SCREEN, WHERE AN AGENT ADDS REFERRAL INFORMATION
  // THEN SENDS IT TO A DATABASE
  Widget _referScreen() {
    int? referralCount;

    Future<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>>
        addReferralData() async {
      DatabaseReference refReferral = FirebaseDatabase.instance
          .ref('referrals/${widget.clientId}/${widget.agentId}')
          .push();
      await refReferral.set({
        'referral_name': referralName.text,
        'referral_mobile': referralMobile.text,
        'referral_email': referralEmail.text,
        'agent_id': widget.agentId,
        'client_id': widget.clientId
      });
      DatabaseReference agentReferrals = FirebaseDatabase.instance.ref();
      final snapshot = await agentReferrals
          .child('referrals/${widget.clientId}/${widget.agentId}')
          .get();
      Map fetchedDataMap = snapshot.value as Map;
      if (fetchedDataMap.length == 1) {
        referralCount = 1;
      } else {
        referralCount = fetchedDataMap.length - 1;
      }
      // UPDATING THE REFERRAL COUNT IN THE AGENT END OF THE NoSQL database
      DatabaseReference updateRefCountAgentEnd =
          FirebaseDatabase.instance.ref();
      updateRefCountAgentEnd
          .child("agents/${widget.clientId}/${widget.agentId}")
          .update({'referral_count': referralCount});

      // UPDATING THE REFERRAL COUNT IN THE REFERRAL END OF THE NoSQL database
      DatabaseReference updateRefCount = FirebaseDatabase.instance.ref();
      updateRefCount.child("referrals/${widget.clientId}/${widget.agentId}");
      await updateRefCount
          .child('referrals/${widget.clientId}/${widget.agentId}')
          .update({'referral_count': referralCount});
      setState(() {
        displayedReferralCount = referralCount!;
      });

      referralName.clear();
      referralMobile.clear();
      referralEmail.clear();
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('REFERRAL ADDED SUCCESSFULLY')),
      );
    }

    Future showAddReferralPrompt() {
      return showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'CONFIRM DETAILS',
              style: TextStyle(color: Colors.blue, fontSize: 20),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('REFERRAL NAME: ${referralName.text}\n'),
                  Text('REFERRAL MOBILE: ${referralMobile.text}\n'),
                  Text('REFERRAL EMAIL: ${referralEmail.text}\n'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('GO BACK',
                    style: TextStyle(color: Colors.black, fontSize: 15)),
              ),
              TextButton(
                onPressed: () {
                  addReferralData();
                  return Navigator.pop(context);
                },
                child: const Text('ADD REFERRAL',
                    style: TextStyle(color: Colors.blue, fontSize: 15)),
              ),
            ],
          );
        },
      );
    }

    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 25),
              SizedBox(
                width: 250,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  controller: referralName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'REFERRAL NAME',
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: 250,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  controller: referralMobile,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'MOBILE NUMBER',
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: 250,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  controller: referralEmail,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'EMAIL',
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      showAddReferralPrompt();
                    }
                  },
                  child: const Text(
                    'ADD REFERRAL',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //
  Widget _seeReferralScreen() {
    Future<Map<dynamic, dynamic>> getReferralData() async {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref
          .child('referrals/${widget.clientId}/${widget.agentId}')
          .get();
      Map? fetchedDataMap;

      if (snapshot.exists) {
        fetchedDataMap = snapshot.value as Map;
        fetchedDataMap.remove("referral_count");
        referralDataMap = fetchedDataMap;
        return referralDataMap;
      } else {
        return {};
      }
    }

    return FutureBuilder(
        future: getReferralData(),
        builder: (context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
          return snapshot.hasData
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
                        child: SizedBox(
                          width: 500,
                          height: 25,
                          child: Text(
                            'REFERRAL COUNT: $displayedReferralCount',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                      for (var refData in referralDataMap.values)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: SizedBox(
                            width: 500,
                            height: 75,
                            child: ListTile(
                              leading: Image.asset(
                                  'assets/images/saapp_icon.png',
                                  scale: 7),
                              title: Text(
                                  "REFERRAL NAME: ${refData['referral_name']}",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 20)),
                              subtitle: Text(
                                  "REFERRAL EMAIL:${refData['referral_email']}\nREFERRAL MOBILE: ${refData['referral_mobile']}",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 15)),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  // PASSWORD CHANGE SCREEN, NO BRAINER
  Widget _changePasswordScreen() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 25),
            Image.asset('assets/images/saapp_icon.png', scale: 3),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                      controller: oldPassword,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'OLD PASSWORD',
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      controller: newPassword,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'NEW PASSWORD',
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          changePassword();
                        }
                      },
                      child: const Text(
                        'CHANGE PASSWORD',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadScreen();
  }

  void _loadScreen() {
    switch (_currentIndex) {
      case 0:
        return setState(() => _currentWidget = _calculateScreen());
      case 1:
        return setState(() => _currentWidget = _referScreen());
      case 2:
        return setState(() => _currentWidget = _seeReferralScreen());
      case 3:
        return setState(() => _currentWidget = _changePasswordScreen());
    }
  }

  void clearScreen() {
    loanAmountGiven.clear();
    loanYearlyRateGiven.clear();
    loanPeriodYearsGiven.clear();
  }

  // METHOD THAT CALCULATE LRS BASED ON INPUT
  // THEN RETURNS
  List<List<dynamic>> calculateLRS(double presentValue, double rate,
      int numberOfYears, String interestType) {
    // HANDLES CALCULATIONS
    String year;
    if (numberOfYears > 1) {
      year = 'YEARS';
    } else {
      year = 'YEAR';
    }
    var commaFormat = NumberFormat("###,###,###", "en_US");
    double loanAmount = presentValue;
    double loanYearlyRate = rate / 100;
    int numberOfPeriods = numberOfYears * 12;
    int startMonth = 1;
    if (interestType == 'Reducing Balance') {
      // REDUCING BALANCE INTEREST CALCULATION
      int loanMonthlyPayment = (((loanAmount * loanYearlyRate / 12) *
              pow((1 + loanYearlyRate / 12), (5 * 12)) /
              (pow((1 + loanYearlyRate / 12), (5 * 12)) - 1)))
          .round();

      int workingLoanAmount = loanAmount.round();
      List loanRepaymentSchedule = [
        [
          'Loan Amount:',
          'KES. ${commaFormat.format(workingLoanAmount)}',
          " ",
          " ",
          " "
        ],
        [
          'Total Payable Amount:',
          'KES. ${commaFormat.format(loanMonthlyPayment * numberOfPeriods)}',
          " ",
          " ",
          " "
        ],
        [
          'Interest Accrued:',
          'KES. ${commaFormat.format((loanMonthlyPayment * numberOfPeriods) - workingLoanAmount)}',
          " ",
          " ",
          " "
        ],
        ['Interest Type:', '$interestType Interest', " ", " ", " "],
        ['Yearly Rate:', '${(loanYearlyRate * 100).toInt()}%', "", "", "", ""],
        ['Loan Period:', '$numberOfYears $year', " ", " ", " "],
        ['Months', 'EMI', 'Interest', 'Principal', 'Balance'],
        [0, " ", " ", " ", commaFormat.format(workingLoanAmount)],
      ];

      int loanInterest = 0;
      int loanPrincipal = 0;
      int loanBalance = 0;
      int totalLoanPrincipal = 0;
      int totalLoanInterest = 0;
      int totalLoanMonthlyPayments = 0;

      for (startMonth; startMonth <= numberOfPeriods; startMonth++) {
        loanInterest = (workingLoanAmount * (loanYearlyRate / 12)).round();
        loanPrincipal = (loanMonthlyPayment - loanInterest);
        loanBalance = (workingLoanAmount - loanPrincipal).round();

        List monthlyRecord = [
          startMonth,
          commaFormat.format(loanMonthlyPayment),
          commaFormat.format(loanInterest),
          commaFormat.format(loanPrincipal),
          commaFormat.format(loanBalance),
        ];
        totalLoanPrincipal += loanPrincipal;
        totalLoanInterest += loanInterest;
        totalLoanMonthlyPayments += loanMonthlyPayment;
        loanRepaymentSchedule.add(monthlyRecord);
        workingLoanAmount = loanBalance;
      }
      List totalsRecord = [
        " ",
        commaFormat.format(loanMonthlyPayment),
        commaFormat.format(totalLoanInterest),
        commaFormat.format(totalLoanPrincipal),
        commaFormat.format(totalLoanMonthlyPayments),
      ];
      List totalsRecordLabelsFooter = [
        "",
        "EMI",
        "Total Interest",
        "Total Principal",
        "Total Payment",
      ];
      loanRepaymentSchedule.add(totalsRecord);
      loanRepaymentSchedule.add(totalsRecordLabelsFooter);
      final theWorkingList = List<List<dynamic>>.from(loanRepaymentSchedule);
      return theWorkingList;
    } else {
      // CALCULATING SIMPLE INTEREST
      // SI = PRT
      double totalInterest = loanAmount * loanYearlyRate * numberOfYears;
      double totalPayableAmount = totalInterest + loanAmount;
      double loanMonthlyPayment = totalPayableAmount / numberOfPeriods;
      double totalPrincipal = totalPayableAmount - totalInterest;

      int workingLoanAmount = totalPayableAmount.round();

      // HEADERS FOR THE CSV FILE, SORTED IN AN ARRAY
      List loanRepaymentSchedule = [
        [
          'Loan Amount:',
          'KES. ${commaFormat.format(loanAmount)}',
          " ",
          " ",
          " "
        ],
        [
          'Total Payable Amount:',
          'KES. ${commaFormat.format(totalPayableAmount)}',
          " ",
          " ",
          " "
        ],
        [
          'Interest Accrued:',
          'KES. ${commaFormat.format(totalPayableAmount - loanAmount)}',
          " ",
          " ",
          " "
        ],
        ['Interest Type:', '$interestType Interest', " ", " ", " "],
        ['Yearly Rate:', '${(loanYearlyRate * 100)}%', "", "", "", ""],
        ['Loan Period:', '$numberOfYears $year', " ", " ", " "],
        ['Months', 'EMI', 'Interest', 'Principal', 'Balance'],
        [0, " ", " ", " ", commaFormat.format(totalPayableAmount)],
      ];

      int loanInterest = 0;
      int loanPrincipal = 0;
      int loanBalance = 0;
      int totalLoanPrincipal = 0;
      int totalLoanInterest = 0;
      int totalLoanMonthlyPayments = 0;

      for (startMonth; startMonth <= numberOfPeriods; startMonth++) {
        loanInterest = (totalInterest / numberOfPeriods).round();
        loanPrincipal = (loanMonthlyPayment - loanInterest).round();
        loanBalance = (totalPayableAmount - loanMonthlyPayment).round();

        List monthlyRecord = [
          startMonth,
          commaFormat.format(loanMonthlyPayment),
          commaFormat.format(loanInterest),
          commaFormat.format(loanPrincipal),
          commaFormat.format(loanBalance),
        ];
        totalLoanPrincipal += loanPrincipal;
        totalLoanInterest += loanInterest;
        totalLoanMonthlyPayments += loanMonthlyPayment.round();
        loanRepaymentSchedule.add(monthlyRecord);
        totalPayableAmount = loanBalance.toDouble();
      }

      List totalsRecord = [
        " ",
        commaFormat.format(loanMonthlyPayment),
        commaFormat.format(totalLoanInterest),
        commaFormat.format(totalLoanPrincipal),
        commaFormat.format(totalLoanMonthlyPayments),
      ];
      List totalsRecordLabelsFooter = [
        "",
        "EMI",
        "Total Interest",
        "Total Principal",
        "Total Payment",
      ];
      loanRepaymentSchedule.add(totalsRecord);
      loanRepaymentSchedule.add(totalsRecordLabelsFooter);
      final theWorkingList = List<List<dynamic>>.from(loanRepaymentSchedule);
      return theWorkingList;
    }
  }

  // CONVERTS WORKING LIST TO CSV DATA
  Future<List<List<dynamic>>> displayData(String path) async {
    final csvFile = File(path).openRead();
    return await csvFile
        .transform(utf8.decoder)
        .transform(
          const CsvToListConverter(),
        )
        .toList();
  }

  // ASYNC METHOD TO CHECK INPUT AND VALIDATE IT
  generateCSV(interestType) async {
    if (double.tryParse(loanAmountGiven.text) == null ||
        double.tryParse(loanYearlyRateGiven.text) == null ||
        int.tryParse(loanPeriodYearsGiven.text) == null) {
      return showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('CALCULATION ERROR'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text("Invalid Value(s) Entered"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('RE-ENTER'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      var theWorkingList = calculateLRS(
          double.parse(loanAmountGiven.text),
          double.parse(loanYearlyRateGiven.text),
          int.parse(loanPeriodYearsGiven.text),
          interestType);
      String csvData = const ListToCsvConverter().convert(theWorkingList);
      String dir = (await getApplicationSupportDirectory()).path;
      String path = "$dir/csv-${DateTime.now()}.csv";
      File file = File(path);
      await file.writeAsString(csvData);
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return displayScreen(
            path, loanAmountGiven.text, loanPeriodYearsGiven.text);
      }));
    }
  }

  Widget displayScreen(String path, amount, years) {
    var commaFormat = NumberFormat("###,###,###", "en_US");
    amount = int.parse(amount);
    years = int.parse(years);
    String year;
    if (years > 1) {
      year = 'YEARS';
    } else {
      year = 'YEAR';
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'LOG: [LRS for KES. ${commaFormat.format(amount)} in $years $year]',
          style: const TextStyle(fontSize: 17),
        ),
      ),
      body: FutureBuilder(
        future: displayData(path),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          return snapshot.hasData
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: snapshot.data!
                          .map(
                            (data) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 7),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Theme.of(context)
                                                .dividerColor))),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      data[0].toString(),
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                    Text(
                                      data[1].toString(),
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                    Text(
                                      data[2].toString(),
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                    Text(
                                      data[3].toString(),
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                    Text(
                                      data[4].toString(),
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }

  // METHODS THAT EFFECTS PASSWORD CHANGES
  Future<void> changePassword() async {
    String oldPass = oldPassword.text;
    String newPass = newPassword.text;

    final ref = FirebaseDatabase.instance.ref();
    final snapshot =
        await ref.child('agents/${widget.clientId}/${widget.agentId}').get();
    if (snapshot.exists) {
      Map fetchedAgentData = snapshot.value as Map;
      String fetchedPassword = fetchedAgentData['agent_password'];
      if (oldPass != fetchedPassword) {
        incorrectOldPassword();
      } else if (oldPass == fetchedPassword) {
        if (fetchedPassword == newPass) {
          samePasswordEntered();
        } else {
          await ref.update({
            "agents/${widget.clientId}/${widget.agentId}/agent_password":
                newPass,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('PASSWORD CHANGED SUCCESSFULLY')),
          );
        }
      }
    } else {
      agentNonExistent();
    }
  }

  // METHODS USED IN PASSWORD CHANGE VALIDATION
  Future agentNonExistent() {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('PASSWORD CHANGE ERROR'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Agent Does Not Exist'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('TRY AGAIN'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // METHODS USED IN PASSWORD CHANGE VALIDATION
  Future samePasswordEntered() {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('PASSWORD CHANGE ERROR'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('New Password Cannot be the Old Password'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Re-Enter'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // METHODS USED IN PASSWORD CHANGE VALIDATION
  Future incorrectOldPassword() {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('PASSWORD CHANGE ERROR'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Old Password Entered Doesn't Match"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Re-Enter'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Welcome, ${widget.agentId}!'),
      ),
      body: _currentWidget,
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
            _loadScreen();
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate),
              label: 'Calculate',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Refer'),
            BottomNavigationBarItem(
                icon: Icon(Icons.people), label: 'Referrals'),
            BottomNavigationBarItem(
                icon: Icon(Icons.password), label: 'Password'),
          ]),
    );
  }
}
