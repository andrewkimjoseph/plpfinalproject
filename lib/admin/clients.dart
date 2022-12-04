// ignore_for_file: use_build_context_synchronously

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../agent/home.dart';

// GLOBAL DECLARATIONS
final clientId = TextEditingController();
final clientPassword = TextEditingController();
final clientName = TextEditingController();
final clientLocation = TextEditingController();
final clientEmail = TextEditingController();
final clientMobile = TextEditingController();
final deleteClientId = TextEditingController();
var clientDataMap = {};

class AddClient extends StatefulWidget {
  const AddClient({super.key});
  @override
  State<AddClient> createState() => _AddClient();
}

class _AddClient extends State<AddClient> {
  void clearData() {
    clientId.clear();
    clientPassword.clear();
    clientName.clear();
    clientLocation.clear();
    clientEmail.clear();
    clientMobile.clear();
  }

  Future<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>>
      addData() async {
    final ref = FirebaseDatabase.instance.ref();

    final snapshot = await ref.child('clients/${clientId.text}').get();
    if (snapshot.exists) {
      clientId.clear();
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('CLIENT ID ALREADY EXISTS, KINDLY CREATE NEW ONE')),
      );
    } else {
      ref.child('clients/${clientId.text}').update({
        "client_id": clientId.text,
        "client_password":
            "0000", // DEFAULT PASSWORD THROUGHOUT THE APP, EXCEPT ADMIN END
        "client_name": clientName.text,
        "client_location": clientLocation.text,
        "client_email": clientEmail.text,
        "client_mobile": clientMobile.text,
      });
      clearData();
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CLIENT ADDED SUCCESSFULLY')),
      );
    }
  }

  Future showAddClientPrompt() {
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
                Text('Client ID: ${clientId.text}\n'),
                Text('Client Name: ${clientName.text}\n'),
                Text('Client Location: ${clientLocation.text}\n'),
                Text('Client Email: ${clientEmail.text}\n'),
                Text('Client Mobile: ${clientMobile.text}'),
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
              child: const Text('ADD CLIENT',
                  style: TextStyle(color: Colors.blue, fontSize: 15)),
            ),
          ],
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>(); // HANDLES FORM VALIDATION

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Admin End'),
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
                    const SizedBox(
                      height: 25,
                    ),
                    TextLabels.thickMontserrat('CLIENT ADD', 35),
                    const SizedBox(
                      height: 25,
                    ),
                    Image.asset('assets/images/client.png', scale: 4),
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
                        controller: clientId,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'CLIENT ID',
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
                        controller: clientName,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'CLIENT NAME',
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 350,
                      height: 75,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        controller: clientLocation,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'CLIENT LOCATION',
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
                        controller: clientEmail,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'CLIENT EMAIL',
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
                        controller: clientMobile,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'CLIENT MOBILE',
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 350.0,
                      height: 75,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(100, 50),
                              maximumSize: const Size(100, 50),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                showAddClientPrompt();
                              }
                            },
                            child: const Text(
                              'ADD CLIENT',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 25),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(100, 50),
                              maximumSize: const Size(100, 50),
                            ),
                            onPressed: () {
                              clearData();
                            },
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

class DeleteClient extends StatefulWidget {
  const DeleteClient({super.key});
  @override
  State<DeleteClient> createState() => _DeleteClient();
}

class _DeleteClient extends State<DeleteClient> {
  Future showDeleteClientPrompt() async {
    final ref = FirebaseDatabase.instance.ref();
    final clientDetails =
        await ref.child('clients/${deleteClientId.text}').get();

    if (clientDetails.exists) {
      Map fetchedClientDataMap = clientDetails.value as Map;
      String fetchedClientName = fetchedClientDataMap['client_name'];
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
                      "You're About to Delete [$fetchedClientName] From Your List..."),
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
                  deleteClientEntered();
                  return Navigator.pop(context);
                },
                child: const Text('DELETE CLIENT',
                    style: TextStyle(color: Colors.blue, fontSize: 15)),
              ),
            ],
          );
        },
      );
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("CLIENT DOES NOT EXIST!")));
    }
  }

  Future<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>>
      deleteClientEntered() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('clients/${deleteClientId.text}').get();
    if (snapshot.exists) {
      final deleteClientRef = ref.child('clients').child(deleteClientId.text);
      deleteClientRef.remove();
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CLIENT DELETED SUCCESSFULLY')),
      );
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("CLIENT DOES NOT EXIST!")),
      );
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Admin End'),
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
                  TextLabels.thickMontserrat('DELETE CLIENT', 35),
                  const SizedBox(height: 25),
                  Image.asset('assets/images/client.png', scale: 3),
                  const SizedBox(height: 25),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: 200.0,
                    height: 100,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                      controller: deleteClientId,
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'e.g., saapp_001',
                        labelText: 'ENTER CLIENT ID',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 50),
                      maximumSize: const Size(100, 50),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDeleteClientPrompt();
                      }
                    },
                    child: const Text(
                      'DELETE',
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

class ViewClients extends StatefulWidget {
  const ViewClients({super.key});
  @override
  State<ViewClients> createState() => _ViewClients();
}

class _ViewClients extends State<ViewClients> {
  Future<Map<dynamic, dynamic>> getClientData() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('clients').get();
    Map fetchedDataMap = snapshot.value as Map;
    clientDataMap = fetchedDataMap;
    return clientDataMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('ALL CLIENTS'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/grey-bg.jpg"),
                fit: BoxFit.cover)),
        child: FutureBuilder(
          future: getClientData(),
          builder: (context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
            return snapshot.hasData
                ? SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 25),
                          TextLabels.thickMontserrat('ALL CLIENTS', 35),
                          const SizedBox(height: 25),
                          for (var clientData in clientDataMap.values)
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
                                            "CLIENT NAME: ${clientData['client_name']}\nCLIENT ID: [${clientData['client_id']}]"),
                                        // subtitle: Text(
                                        //   "REFERRAL MOBILE: ${refData['referral_mobile']}",
                                        //   style: const TextStyle(fontSize: 18),
                                        // ),
                                      ),
                                      // TextLabels.thickMontserrat('Hey', 15)
                                    ],
                                  ),
                                ),
                                // ListTile(
                                //   leading: Image.asset(
                                //       'assets/images/logo/saapp_icon.png',
                                //       scale: 7),
                                //   title: Text(""),
                                // ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}
