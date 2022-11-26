// ignore_for_file: use_build_context_synchronously

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'clients.dart';

final newId = TextEditingController();
final newPassword = TextEditingController();

class HomeSAApp extends StatefulWidget {
  const HomeSAApp({super.key});
  @override
  State<HomeSAApp> createState() => _HomeSAApp();
}

class _HomeSAApp extends State<HomeSAApp> {
  var _currentIndex = 0;
  Widget _currentWidget = Container(); // HELPS TO SWITCH BETWEEN WIDGETS

  // 1. THE CLIENT SCREEN
  Widget _clientScreen() {
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
                          builder: (context) => const AddClient()),
                    );
                  },
                  child: const Text(
                    'ADD CLIENT',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Image.asset('assets/images/saapp_icon.png', scale: 9),
              const SizedBox(height: 15),
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
                          builder: (context) => const DeleteClient()),
                    );
                  },
                  child: const Text(
                    'DELETE CLIENT',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Image.asset('assets/images/saapp_icon.png', scale: 9),
              const SizedBox(height: 15),
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
                          builder: (context) => const ViewClients()),
                    );
                  },
                  child: const Text(
                    'VIEW CLIENTS',
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

  final _formKey = GlobalKey<FormState>(); // HANDLES FORM VALIDATION

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
    String enteredId = newId.text;
    String enteredPassword = newPassword.text;
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('admin').get();
    if (snapshot.exists) {
      Map fetchedDataMap = snapshot.value as Map;
      String fetchedId = fetchedDataMap['id'];
      String fetchedPassword = fetchedDataMap['password'];
      if (enteredId == fetchedId || enteredPassword == fetchedPassword) {
        changeErrorSameCredentials();
      } else {
        ref
            .child('admin')
            .update({'id': enteredId, 'password': enteredPassword});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PASSWORD CHANGED SUCCESSFULLY')),
        );
      }
    }
  }

  // 2. CHANGE PASSWORD SCREEN
  Widget _changePasswordScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/images/saapp_icon.png', scale: 7),
          const SizedBox(height: 25),
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
                    controller: newId,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'NEW ID',
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
    );
  }

  @override
  void initState() {
    super.initState();
    _loadScreen();
  }

  // OPERATES LIKE A SWITCH BOARD DEPENDING ON ITEM CLICKED
  void _loadScreen() {
    switch (_currentIndex) {
      case 0:
        return setState(() => _currentWidget = _clientScreen());
      case 1:
        return setState(() => _currentWidget = _changePasswordScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Admin End'),
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
              icon: Icon(Icons.people),
              label: 'Clients',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.password), label: 'Password'),
          ]),
    );
  }
}
