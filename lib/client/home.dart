// ignore_for_file: use_build_context_synchronously

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'agents.dart';

final newPassword = TextEditingController();

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
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
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
              Image.asset('assets/images/saapp_icon.png', scale: 7),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
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
              Image.asset('assets/images/saapp_icon.png', scale: 7),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
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
      ),
    );
  }

  Future<Map<dynamic, dynamic>> getReferralData() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('referrals/${widget.clientId}').get();
    Map? fetchedDataMap;
    if (snapshot.exists) {
      for (DataSnapshot agentSnapshots in snapshot.children) {
        // for (DataSnapshot agentSnapshot in agentSnapshots.children) {
        fetchedDataMap = agentSnapshots.value as Map;
        fetchedDataMap.remove("referral_count");
      }
      referralDataMap = fetchedDataMap!;
      return referralDataMap;
    } else {
      return {};
    }
  }

  // ------------------------------------------------------------- //

  // 2. THE REFERRAL SCREEN
  Widget _referralsScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (var refData in referralDataMap.values)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: SizedBox(
                  width: 500,
                  height: 75,
                  child: ListTile(
                    leading:
                        Image.asset('assets/images/saapp_icon.png', scale: 7),
                    title: Text("REFERRAL NAME: ${refData['referral_name']}",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20)),
                    subtitle: Text(
                        "REFERRAL EMAIL:${refData['referral_email']}\nREFERRAL MOBILE: ${refData['referral_mobile']}",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 15)),
                  ),
                ),
              ),
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
  // 3. CHANGE PASSWORD SCREEN
  Widget _changePasswordScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/images/saapp_icon.png', scale: 3),
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
    getReferralData();
    _loadScreen();
  }

  void _loadScreen() {
    switch (_currentIndex) {
      case 0:
        return setState(() => _currentWidget = _agentsScreen());
      case 1:
        return setState(() => _currentWidget = _referralsScreen());
      case 2:
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
      body: _currentWidget,
      bottomNavigationBar: BottomNavigationBar(
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
                icon: Icon(Icons.password), label: 'Password'),
          ]),
    );
  }
}
