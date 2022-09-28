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
  runApp(const SAApp());
}

class SAApp extends StatelessWidget {
  const SAApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The SAApp Platform',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
      ),
      home: const Continue(title: '🏦 SAApp - Engage to Convert 👌'),
    );
  }
}
