// ignore_for_file: use_build_context_synchronously

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:saapp/agent/home.dart';
import 'package:saapp/client/performance.dart';
import 'package:saapp/main.dart';
import 'agents.dart';

final newPassword = TextEditingController();
var referralDataMapAllAgents = {};
var referralDataMap = {};
int refCount = 0;
int totalAmount = 0;

class HomeClient extends StatefulWidget {
  const HomeClient({super.key, required this.clientId});
  final String clientId;
  @override
  State<HomeClient> createState() => _HomeClient();
}

class _HomeClient extends State<HomeClient> {
  var _currentIndex = 0;
  Widget _currentWidget = Container();
  final _formKey = GlobalKey<FormState>(); // HANDLES FORM VALIDATION

  // 1. THE AGENT SCREEN
  Widget _agentsScreen() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            TextLabels.thickMontserrat('AGENT SCREEN', 35),
            const SizedBox(height: 25),
            Image.asset('assets/images/agent.png', scale: 2),
            const SizedBox(height: 25),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddAgent(clientId: widget.clientId)),
                  );
                },
                child: const Text(
                  'ADD AGENT',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Image.asset('assets/images/logo/saapp_icon.png', scale: 7),
            const SizedBox(height: 15),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DeleteAgent(clientId: widget.clientId)),
                  );
                },
                child: const Text(
                  'DELETE AGENT',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Image.asset('assets/images/logo/saapp_icon.png', scale: 7),
            const SizedBox(height: 15),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ViewAgent(clientId: widget.clientId)),
                  );
                },
                child: const Text(
                  'VIEW AGENTS',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<dynamic, dynamic>> getReferralDataForClient() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('referrals/${widget.clientId}').get();
    Map? fetchedDataMap = {};
    for (DataSnapshot agentSnapshot in snapshot.children) {
      fetchedDataMap.addAll(agentSnapshot.value as Map);
      fetchedDataMap.remove("referral_count");
    }

    referralDataMapAllAgents = fetchedDataMap;
    return referralDataMapAllAgents;
  }

  // ------------------------------------------------------------- //

  // 2. THE REFERRAL SCREEN
  //
  Widget _referralsScreen() {
    return Center(
      child: FutureBuilder(
          future: getReferralDataForClient(),
          builder: (context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
            return snapshot.hasData
                ? SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 25),
                        TextLabels.thickMontserrat('ALL AGENT REFERRALS', 35),
                        const SizedBox(height: 25),
                        Image.asset('assets/images/referrals.png', scale: 3),
                        const SizedBox(height: 25),
                        for (var refData in referralDataMapAllAgents.values)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: SizedBox(
                              width: 500,
                              height: 75,
                              child: Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    ListTile(
                                      leading: Image.asset(
                                          'assets/images/person.png',
                                          scale: 12),
                                      // leading: const Icon(Icons.check),
                                      title: Text(
                                          "REFERRAL NAME: ${refData['referral_name']}"),
                                      subtitle: Text(
                                        "REFERRAL MOBILE: ${refData['referral_mobile']}",
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    // TextLabels.thickMontserrat('Hey', 15)
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          }),
    );
  }

  // 3. THE METRIC SCREEN
  Widget _metricsScreen() {
    Future<Map<dynamic, dynamic>> getAgentData() async {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('agents/${widget.clientId}').get();
      Map fetchedDataMap = snapshot.value as Map;
      agentDataMap = fetchedDataMap;
      return agentDataMap;
    }

    Future<List<int>> getPerformanceDataForClient() async {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('referrals/${widget.clientId}').get();
      final fetchedDataMap = snapshot.value as Map;
      int totalreferralCount = 0;
      int totalReferralAmountCurrentAgent = 0;

      for (var agentData in fetchedDataMap.values) {
        for (var refData in agentData.keys) {
          if (refData.contains("referral_count")) {
            continue;
          } else {
            totalreferralCount += 1;
          }
        }
      }

      for (var agentData in fetchedDataMap.values) {
        for (var refData in agentData.values) {
          // ignore: unnecessary_null_comparison
          if (refData is int) {
            continue;
          } else {
            int amount = refData['referral_amount'];
            totalReferralAmountCurrentAgent += amount;
          }
        }
      }

      return [totalreferralCount, totalReferralAmountCurrentAgent];
    }

    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
                future: getPerformanceDataForClient(),
                builder: (context, AsyncSnapshot<List<int>> snapshot) {
                  // print(snapshot.data?.values);
                  return snapshot.hasData
                      ? SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(height: 25),
                              TextLabels.thickMontserrat(
                                  'AGENT PERFORMANCE & LOAN UPDATING', 30),
                              const SizedBox(height: 25),
                              TextLabels.thickMontserrat(
                                  'ALL-TIME PERFORMANCE (ALL AGENTS)', 20),
                              const SizedBox(height: 25),
                              BarChartWithSecondaryAxis.withSampleData(
                                amount: snapshot.data![1],
                                referrals: snapshot.data![0],
                              ),
                              const SizedBox(height: 25),
                            ],
                          ),
                        )
                      : const Center(
                          // child: Text('Loading...'),
                          );
                }),
            FutureBuilder(
                future: getAgentData(),
                builder:
                    (context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
                  return snapshot.hasData
                      ? SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              TextLabels.thickMontserrat('AGENTS', 20),
                              const SizedBox(height: 10),
                              for (var agentData in agentDataMap.values)
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 500,
                                          height: 75,
                                          child: ListTile(
                                            leading: Image.asset(
                                                'assets/images/agent.png',
                                                scale: 7),
                                            title: Text(
                                                "AGENT NAME: ${agentData['agent_name']}\nAGENT ID: [${agentData['agent_id']}]"),
                                            onTap: () {},
                                          ),
                                        ),
                                        ButtonBar(
                                          children: <Widget>[
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blue),
                                              child: const Text(
                                                'ADD LOAN(S) / CHECK METRICS',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AgentReferralPerformance(
                                                            clientId:
                                                                widget.clientId,
                                                            agentId:
                                                                "${agentData['agent_id']}",
                                                          )),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        // TextLabels.thickMontserrat('Hey', 15)
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        );
                }),
          ],
        ),
      ),
    );
  }

  Future<void> changeErrorSameCredentials() {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('PASSWORD CHANGE ERROR'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('OLD ID/PASSWORD DETECTED'),
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
  }

  Future<void> changePassword() async {
    String enteredPassword = newPassword.text;
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('clients/${widget.clientId}').get();
    if (snapshot.exists) {
      Map fetchedDataMap = snapshot.value as Map;
      String fetchedPassword = fetchedDataMap['client_password'];
      if (enteredPassword == fetchedPassword) {
        changeErrorSameCredentials();
      } else {
        ref
            .child('clients/${widget.clientId}')
            .update({'client_password': enteredPassword});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PASSWORD CHANGED SUCCESSFULLY')),
        );
      }
    }
  }

  // -------------------------------------------------------- //
  // 4. CHANGE PASSWORD SCREEN
  Widget _changePasswordScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextLabels.thickMontserrat('PASSWORD SCREEN', 35),
          const SizedBox(height: 25),
          Image.asset('assets/images/client.png', scale: 3),
          const SizedBox(height: 25),
          Form(
            key: _formKey,
            child: Column(
              children: [
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
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
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
        return setState(() => _currentWidget = _agentsScreen());
      case 1:
        return setState(() => _currentWidget = _referralsScreen());
      case 2:
        return setState(() => _currentWidget = _metricsScreen());
      case 3:
        return setState(() => _currentWidget = _changePasswordScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Welcome, ${widget.clientId}!'),
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/grey-bg.jpg"),
                fit: BoxFit.cover),
          ),
          child: _currentWidget),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
            _loadScreen();
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.support_agent),
              label: 'Agents',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.people), label: 'Referrals'),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart), label: 'Metrics'),
            BottomNavigationBarItem(
                icon: Icon(Icons.password), label: 'Password'),
          ]),
    );
  }
}

class AgentReferralPerformance extends StatefulWidget {
  const AgentReferralPerformance({
    super.key,
    required this.agentId,
    required this.clientId,
  });
  final String agentId;
  final String clientId;

  @override
  State<AgentReferralPerformance> createState() => _AgentReferralPerformance();
}

class _AgentReferralPerformance extends State<AgentReferralPerformance> {
  Future<Map<dynamic, dynamic>> getReferralData(clientId, agentId) async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('referrals/$clientId/$agentId').get();
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

  Future<List<int>> getPerformanceDataForAgentReferralCount(agentId) async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot =
        await ref.child('referrals/${widget.clientId}/$agentId').get();
    final fetchedDataMap = snapshot.value as Map;
    int referralCount = 0;
    referralCount = fetchedDataMap['referral_count'];
    fetchedDataMap.remove('referral_count');
    int totalReferralAmountCurrentAgent = 0;
    for (var refData in fetchedDataMap.values) {
      totalReferralAmountCurrentAgent += refData['referral_amount']! as int;
    }
    return [referralCount, totalReferralAmountCurrentAgent];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Agent-Referral Performance'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/grey-bg.jpg"),
              fit: BoxFit.cover),
        ),
        child: Center(
          child: SingleChildScrollView(
              child: Column(
            children: [
              // PERFORMANCE DATA
              FutureBuilder(
                  future:
                      getPerformanceDataForAgentReferralCount(widget.agentId),
                  builder: (context, AsyncSnapshot<List<int>> snapshot) {
                    return snapshot.hasData
                        ? SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(
                                  height: 25,
                                ),
                                TextLabels.thickMontserrat(
                                    'REFERRALS\nfor\n[${widget.agentId}]', 35),
                                const SizedBox(height: 15),
                                BarChartWithSecondaryAxis.withSampleData(
                                  amount: snapshot.data![1],
                                  referrals: snapshot.data![0],
                                ),
                                // const SizedBox(height: 25),
                              ],
                            ),
                          )
                        : const Center(
                            // child: CircularProgressIndicator(),
                            );
                  }),
              const SizedBox(
                height: 15,
              ),
              FutureBuilder(
                  future: getReferralData(widget.clientId, widget.agentId),
                  builder:
                      (context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
                    return snapshot.hasData
                        ? SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                for (var refData in referralDataMap.values)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 10),
                                    child: SizedBox(
                                      width: 400,
                                      height: 145,
                                      child: Card(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            ListTile(
                                              leading: Image.asset(
                                                  'assets/images/person.png',
                                                  scale: 12),
                                              // leading: const Icon(Icons.check),
                                              title: Text(
                                                  "REFERRAL NAME: ${refData['referral_name']}"),
                                              subtitle: Text(
                                                "REFERRAL MOBILE: ${refData['referral_mobile']}",
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              ),
                                            ),
                                            ButtonBar(
                                              children: <Widget>[
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.blue),
                                                  child: const Text(
                                                      'ADD LOAN AMOUNT'),
                                                  onPressed: () {
                                                    AddReferralAmount
                                                        .addReferralAmountDialogBox(
                                                            theContext: context,
                                                            theAgentId:
                                                                widget.agentId,
                                                            theClientId:
                                                                widget.clientId,
                                                            theReferralId: refData[
                                                                'referral_id']);
                                                  },
                                                ),
                                              ],
                                            ),
                                            // TextLabels.thickMontserrat('Hey', 15)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          );
                  }),
            ],
          )),
        ),
      ),
    );
  }
}

class AddReferralAmount {
  static alertBoxWithoutInputField(
      {required BuildContext theContext,
      required String alertBoxTitle,
      required String alertBoxMessage}) {
    showDialog(
      context: theContext,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alertBoxTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(alertBoxMessage),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor:
                    BuildMaterialColorGenerator.buildMaterialColorGenerator(
                        const Color(0xFF2b334b)),
              ),
              child: const Text(
                'GO BACK',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static validateValueLoanAmountTaken(
      {required String givenLoanAmount,
      required BuildContext currentContext,
      required String idClient,
      required String idAgent,
      required String idReferral}) {
    if (double.tryParse(givenLoanAmount) == null) {
      alertBoxWithoutInputField(
          theContext: currentContext,
          alertBoxTitle: 'INVALID VALUE ENTERED',
          alertBoxMessage: 'Amount must be valid and in KES.');
    } else {
      double loanAmount = double.tryParse(givenLoanAmount)!;
      sendReferralAmountToDatabase(
          clientId: idClient,
          agentId: idAgent,
          loanAmountTaken: loanAmount,
          referralId: idReferral,
          theContext: currentContext);
    }
  }

  static sendReferralAmountToDatabase(
      {required String clientId,
      required String agentId,
      required String referralId,
      required double loanAmountTaken,
      required BuildContext theContext}) async {
    DatabaseReference refReferral = FirebaseDatabase.instance
        .ref('referrals/$clientId/$agentId/$referralId');
    await refReferral
        .update({'referral_amount': loanAmountTaken}).then((value) {
      ScaffoldMessenger.of(theContext).showSnackBar(
        const SnackBar(content: Text("AMOUNT ADDED SUCCESSFULLY")),
      );

      Navigator.of(theContext).pop();
    });
  }

  static addReferralAmountDialogBox(
      {required BuildContext theContext,
      required String theClientId,
      required String theAgentId,
      required String theReferralId}) {
    var loanAmountTaken = TextEditingController();
    showDialog(
      context: theContext,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('ADDING REFERRAL LOAN AMOUNT'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextLabels.thickMontserrat('AMOUNT (KES):', 20),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 250,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                    controller: loanAmountTaken,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'CREDIT AMOUNT GIVEN',
                        hintText: 'in KES'),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:
                        BuildMaterialColorGenerator.buildMaterialColorGenerator(
                            const Color(0xFF2b334b)),
                  ),
                  child: const Text(
                    'GO BACK',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text(
                    'ADD AMOUNT',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    validateValueLoanAmountTaken(
                        givenLoanAmount: loanAmountTaken.text,
                        currentContext: theContext,
                        idClient: theClientId,
                        idAgent: theAgentId,
                        idReferral: theReferralId);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
