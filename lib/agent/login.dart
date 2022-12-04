// import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController clientIdController = TextEditingController();
TextEditingController agentIdController = TextEditingController();
TextEditingController passwordController = TextEditingController();

String enteredClientId =
    'creditouch_${String.fromCharCodes(clientIdController.text.trim().runes.toList().reversed)}';

class LoginAgent extends StatefulWidget {
  const LoginAgent({super.key, required this.title});
  final String title;
  @override
  State<LoginAgent> createState() => _LoginAgent();
}

class _LoginAgent extends State<LoginAgent> {
  Future loginSuccessfulAgent(int refCount) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('LOGIN SUCCESSFUL')),
    );
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomeAgent(
                agentId: agentIdController.text,
                clientId: enteredClientId,
                fetchedRefCount: refCount)));
  }

  Future loginErrorWrongCredentials() {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('LOGIN ERROR'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('WRONG CREDENTIALS'),
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

  Future loginErrorDataNonExistent() {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('LOGIN ERROR'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('AGENT DOES NOT EXIST'),
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

  Future validateAgentLogin() async {
    String enteredAgentId = agentIdController.text;
    String enteredPassword = passwordController.text;
    final ref = FirebaseDatabase.instance.ref();
    final snapshot =
        await ref.child('agents/$enteredClientId/$enteredAgentId').get();
    if (snapshot.exists) {
      Map fetchedDataMap = snapshot.value as Map;
      String fetchedClientId = fetchedDataMap['client_id'];
      String fetchedAgentId = fetchedDataMap['agent_id'];
      String fetchedPassword = fetchedDataMap['agent_password'];

      if (enteredClientId == fetchedClientId &&
          enteredAgentId == fetchedAgentId &&
          enteredPassword == fetchedPassword) {
        // WE NEED TO FETCH REFERRAL DATA FROM THE DATABASE
        // AND HAVE IT ON THE SCREEN
        DatabaseReference getCountRef = FirebaseDatabase.instance.ref();
        final theCount = await getCountRef
            .child("referrals/$enteredClientId/$enteredAgentId")
            .get();
        Map fetchedData = theCount.value as Map;
        int fetchedRefCount = fetchedData['referral_count'];

        return loginSuccessfulAgent(fetchedRefCount);
      } else {
        return loginErrorWrongCredentials();
      }
    } else {
      return loginErrorDataNonExistent();
    }
  }

  void _handleRememberMe(value) {
    _isChecked = value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("remember_me", value);
      prefs.setString("client_id", clientIdController.text.trim());
      prefs.setString("agent_id", agentIdController.text);
      prefs.setString("agent_password", passwordController.text);
    });
    setState(() {
      _isChecked = value;
    });
  }

  void _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var clientId = prefs.getString("client_id") ?? "";
    var agentId = prefs.getString("agent_id") ?? "";
    var agentPassword = prefs.getString("agent_password") ?? "";
    var rememberMe = prefs.getBool("remember_me") ?? false;

    if (rememberMe) {
      setState(() {
        _isChecked = true;
      });
      clientIdController.text = clientId;
      agentIdController.text = agentId;
      passwordController.text = agentPassword;
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool _isChecked = true;
  @override
  void initState() {
    _loadCredentials();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
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
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const SizedBox(
                  height: 25,
                ),
                TextLabels.thickMontserrat('AGENT LOGIN', 35),
                const SizedBox(
                  height: 25,
                ),
                Image.asset('assets/images/agent.png', scale: 3),
                const SizedBox(height: 25),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 0, bottom: 15),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                          controller: clientIdController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'CLIENT NUMBER',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 0, bottom: 0),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                          controller: agentIdController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'AGENT ID',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15, bottom: 0),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'AGENT PASSWORD',
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Checkbox(value: _isChecked, onChanged: _handleRememberMe),
                      const Text('Remember Me',
                          style: TextStyle(color: Colors.blue, fontSize: 15)),
                      const SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              validateAgentLogin();
                            }
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
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
    );
  }
}
