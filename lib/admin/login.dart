// ignore_for_file: use_build_context_synchronously

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController passwordController = TextEditingController();
TextEditingController idController = TextEditingController();

// Creating Class named Gfg

class LoginSAApp extends StatefulWidget {
  const LoginSAApp({super.key, required this.title});
  final String title;
  @override
  State<LoginSAApp> createState() => _LoginSAApp();
}

class _LoginSAApp extends State<LoginSAApp> {
  final _formKey = GlobalKey<FormState>(); // HANDLES FORM VALIDILITY
  bool _isChecked = true;

  // ATTEMPTS TO SAVE LOG IN DETAILS
  void _handleRememberMe(value) {
    _isChecked = value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("remember_me", value);
      prefs.setString("id", idController.text.trim());
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

  Future validateLogins() async {
    var idEntered = idController.text;
    var passwordEntered = passwordController.text;

    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('admin').get();
    if (snapshot.exists) {
      Map fetchedDataMap = snapshot.value as Map;
      String fetchedId = fetchedDataMap['id'];
      String fetchedPassword = fetchedDataMap['password'];
      if (idEntered == fetchedId && passwordEntered == fetchedPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("LOGIN SUCCESSFUL")),
        );
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeSAApp()),
        );
      } else {
        return showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('LOGIN ERROR'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('Wrong ID/Password'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/blue-bg.jpg"),
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
                  Image.asset('assets/images/saapp_icon.png', scale: 3),
                  const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Center(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 0, bottom: 0),
                    // padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                      controller: idController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'ADMIN ID',
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
                        labelText: 'ADMIN PASSWORD',
                      ),
                    ),
                  ),
                  Checkbox(value: _isChecked, onChanged: _handleRememberMe),
                  const SizedBox(height: 5),
                  const Text('Remember Me',
                      style: TextStyle(color: Colors.blue, fontSize: 15)),
                  const SizedBox(height: 5),
                  Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          validateLogins();
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
          ),
        ),
      ),
    );
  }
}
