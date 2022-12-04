import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../agent/home.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController idController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class LoginClient extends StatefulWidget {
  const LoginClient({super.key, required this.title});
  final String title;
  @override
  State<LoginClient> createState() => _LoginClient();
}

class _LoginClient extends State<LoginClient> {
  final _formKey = GlobalKey<FormState>(); // HANDLES FORM VALIDATION
  bool _isChecked = true;
  void _handleRememberMe(value) {
    _isChecked = value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("remember_me", value);
      prefs.setString("id", idController.text);
      prefs.setString("password", passwordController.text);
    });
    setState(() {
      _isChecked = value;
    });
  }

  @override
  void initState() {
    _loadCredentials();
    super.initState();
  }

  // ATTEMPTS TO SAVE DETAILS IN LOCAL STORAGE
  void _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id") ?? "";
    var password = prefs.getString("password") ?? "";
    var rememberMe = prefs.getBool("remember_me") ?? false;

    if (rememberMe) {
      setState(() {
        _isChecked = true;
      });
      idController.text = id;
      passwordController.text = password;
    }
  }

  Future loginSuccessfulClient() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("LOGIN SUCCESSFUL")),
    );
    return Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomeClient(clientId: idController.text)),
    );
  }

  Future loginErrorInvalidRequest() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('LOGIN ERROR'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('CLIENT DOES NOT EXIST!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('RETRY'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
              child: const Text('RETRY'),
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
                Text('CLIENT DOES NOT EXIST!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('RETRY'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future validateClientLogin() async {
    String enteredId = idController.text.trim();
    String enteredPassword = passwordController.text;
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('clients/$enteredId').get();
    if (snapshot.exists) {
      Map fetchedDataMap = snapshot.value as Map;
      String fetchedId = fetchedDataMap['client_id'];
      String fetchedPassword = fetchedDataMap['client_password'];
      if (enteredId == fetchedId && enteredPassword == fetchedPassword) {
        return loginSuccessfulClient();
      } else {
        return loginErrorWrongCredentials();
      }
    } else {
      return loginErrorDataNonExistent();
    }
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const SizedBox(
                    height: 25,
                  ),
                  TextLabels.thickMontserrat('CLIENT LOGIN', 35),
                  const SizedBox(
                    height: 25,
                  ),
                  Image.asset('assets/images/client.png', scale: 3),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 0, bottom: 0),
                    // padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: idController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'CLIENT ID',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 0),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'CLIENT PASSWORD',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Checkbox(value: _isChecked, onChanged: _handleRememberMe),
                  // const SizedBox(height: 0),
                  const Text('Remember Me',
                      style: TextStyle(color: Colors.blue, fontSize: 15)),
                  const SizedBox(height: 25),
                  Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          validateClientLogin();
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
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
