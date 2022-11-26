import 'package:flutter/material.dart';
import 'switchboard/continue.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // BEFORE APP LAUNCHES, CONNECTION TO THE FIREBASE DATABASE IS FIRST ESTABLISHED
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CrediTouch());
}

class CrediTouch extends StatelessWidget {
  const CrediTouch({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CrediTouch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
      ),
      home: const Continue(title: '🏦 CrediTouch - Engage to Convert 👌'),
    );
  }
}
