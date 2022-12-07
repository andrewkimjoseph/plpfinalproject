// ignore_for_file: use_build_context_synchronously

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../agent/home.dart';

final agentId = TextEditingController();
final agentPassword = TextEditingController();
final agentName = TextEditingController();
final agentEmail = TextEditingController();
final agentMobile = TextEditingController();

final viewAgentId = TextEditingController();
final deleteAgentId = TextEditingController();

var agentDataMap = {};
var referralDataMap = {};

class AddAgent extends StatefulWidget {
  const AddAgent({super.key, required this.clientId});
  final String clientId;
  @override
  State<AddAgent> createState() => _AddAgent();
}

class _AddAgent extends State<AddAgent> {
  void clearData() {
    agentId.clear();
    agentPassword.clear();
    agentName.clear();
    agentEmail.clear();
    agentMobile.clear();
  }

  Future<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>>
      addData() async {
    final ref = FirebaseDatabase.instance.ref();

    final snapshot =
        await ref.child('agents/${widget.clientId}/${agentId.text}').get();
    if (snapshot.exists) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('AGENT ID ALREADY EXISTS, KINDLY CREATE NEW ONE')),
      );
    } else {
      ref.child('agents/${widget.clientId}/${agentId.text}').update({
        'agent_id': agentId.text,
        'agent_password': "0000",
        'agent_name': agentName.text,
        'agent_email': agentEmail.text,
        'agent_mobile': agentMobile.text,
        'client_id': widget.clientId,
        'referral_count': 0
      });
      DatabaseReference updateRefCount = FirebaseDatabase.instance.ref();
      updateRefCount.child("referrals/${widget.clientId}/${agentId.text}");
      await updateRefCount
          .child('referrals/${widget.clientId}/${agentId.text}')
          .set({'referral_count': 0});

      clearData();
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('AGENT ADDED SUCCESSFULLY')),
      );
    }
  }

  Future showAddAgentPrompt() {
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
                Text('Agent ID: ${agentId.text}\n'),
                Text('Agent Name: ${agentName.text}\n'),
                Text('Agent Email: ${agentEmail.text}\n'),
                Text('Agent Mobile: ${agentMobile.text}'),
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
                addData();
                return Navigator.pop(context);
              },
              child: const Text('ADD AGENT',
                  style: TextStyle(color: Colors.blue, fontSize: 15)),
            ),
          ],
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Client End'),
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
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextLabels.thickMontserrat('ADD AGENT', 35),
                    const SizedBox(
                      height: 25,
                    ),
                    Image.asset('assets/images/agent.png', scale: 7),
                    const SizedBox(height: 15),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: 350.0,
                      height: 75,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        controller: agentId,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'AGENT ID',
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 350.0,
                      height: 75,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        controller: agentName,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'AGENT NAME',
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 350.0,
                      height: 75,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        controller: agentEmail,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'AGENT EMAIL',
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 350.0,
                      height: 75,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        controller: agentMobile,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'AGENT MOBILE',
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 350.0,
                      height: 75,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(100, 50),
                              maximumSize: const Size(100, 50),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                showAddAgentPrompt();
                              }
                            },
                            child: const Text(
                              'ADD',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 15),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(100, 50),
                              maximumSize: const Size(100, 50),
                            ),
                            onPressed: clearData,
                            child: const Text(
                              'CLEAR FIELDS',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DeleteAgent extends StatefulWidget {
  const DeleteAgent({super.key, required this.clientId});
  final String clientId;
  @override
  State<DeleteAgent> createState() => _DeleteAgent();
}

class _DeleteAgent extends State<DeleteAgent> {
  Future<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>>
      deleteAgentEntered() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child("agents/${widget.clientId}/${deleteAgentId.text}")
        .get();
    if (snapshot.exists) {
      final deleteClientRef =
          ref.child('agents').child(widget.clientId).child(deleteAgentId.text);
      deleteClientRef.remove();
      ref.child('clients');
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('AGENT DELETED SUCCESSFULLY')),
      );
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("AGENT DOES NOT EXIST!")),
      );
    }
  }

  Future showDeleteAgentPrompt() async {
    final ref = FirebaseDatabase.instance.ref();

    final agentDetails = await ref
        .child("agents/${widget.clientId}/${deleteAgentId.text}")
        .get();

    if (agentDetails.exists) {
      Map fetchedAgentDataMap = agentDetails.value as Map;
      String fetchedAgentName = fetchedAgentDataMap['agent_name'];
      return showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'CONFIRM DELETION',
              style: TextStyle(color: Colors.blue, fontSize: 20),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      "You're About to Delete [$fetchedAgentName] From Your List..."),
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
                  deleteAgentEntered();
                  return Navigator.pop(context);
                },
                child: const Text('DELETE AGENT',
                    style: TextStyle(color: Colors.blue, fontSize: 15)),
              ),
            ],
          );
        },
      );
    } else {
      return ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("AGENT DOES NOT EXIST!")));
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('DELETE AGENT'),
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextLabels.thickMontserrat('DELETE AGENT', 35),
                  const SizedBox(height: 25),
                  Image.asset(
                    'assets/images/agent.png',
                    scale: 2,
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: 200.0,
                    height: 75,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                      controller: deleteAgentId,
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'e.g., PC001',
                        labelText: 'ENTER AGENT ID',
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 50),
                      maximumSize: const Size(200, 50),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDeleteAgentPrompt();
                      }
                    },
                    child: const Text(
                      'DELETE AGENT',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ViewAgent extends StatefulWidget {
  const ViewAgent({super.key, required this.clientId});
  final String clientId;
  @override
  State<ViewAgent> createState() => _ViewAgent();
}

class _ViewAgent extends State<ViewAgent> {
  Future<Map<dynamic, dynamic>> getAgentData() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('agents/${widget.clientId}').get();
    Map fetchedDataMap = snapshot.value as Map;
    agentDataMap = fetchedDataMap;
    return agentDataMap;
  }

  @override
  void initState() {
    super.initState();
    getAgentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('ALL AGENTS'),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/grey-bg.jpg"),
                fit: BoxFit.cover),
          ),
          child: FutureBuilder(
              future: getAgentData(),
              builder:
                  (context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
                return snapshot.hasData
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 25),
                            TextLabels.thickMontserrat('AGENTS', 35),
                            const SizedBox(height: 25),
                            Image.asset(
                              'assets/images/agent.png',
                              scale: 5,
                            ),
                            const SizedBox(height: 25),
                            for (var agentData in agentDataMap.values)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: SizedBox(
                                  width: 500,
                                  height: 100,
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
                                              "AGENT NAME: ${agentData['agent_name']}"),
                                          subtitle: Text(
                                            "REFERRAL COUNT: ${agentData['referral_count']}",
                                            style:
                                                const TextStyle(fontSize: 18),
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
        ));
  }
}
