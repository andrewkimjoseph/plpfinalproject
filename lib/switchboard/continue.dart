import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saapp/agent/home.dart';
import '../agent/login.dart';
import '../client/login.dart';
import '../admin/login.dart';

// THIS IS THE SWITCHBOARD THAT ESTABLISHES THE ROUTE A USER TAKES
class Continue extends StatefulWidget {
  const Continue({super.key, required this.title});
  final String title;

  @override
  State<Continue> createState() => _Continue();
}

class _Continue extends State<Continue> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title,
            style: GoogleFonts.rubik(
              textStyle: const TextStyle(
                  color: Colors.white, letterSpacing: .5, fontSize: 25),
            )),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/grey-bg.jpg"),
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Image.asset('assets/images/splash/splash_screen.png', scale: 1),
              const SizedBox(height: 25),
              TextLabels.thickMontserrat('CONTINUE AS:', 25),
              const SizedBox(height: 25),
              ContinueScreenButtons.continueScreenButton(
                particularIcon: Icons.manage_accounts,
                theContext: context,
                buttonText: "ADMIN",
                nextScreen: const LoginSAApp(title: 'Admin Login'),
              ),
              const SizedBox(height: 50),
              ContinueScreenButtons.continueScreenButton(
                particularIcon: Icons.admin_panel_settings,
                theContext: context,
                buttonText: "CLIENT",
                nextScreen: const LoginClient(title: 'Client Login'),
              ),
              const SizedBox(height: 50),
              ContinueScreenButtons.continueScreenButton(
                particularIcon: Icons.person_pin,
                theContext: context,
                buttonText: "AGENT",
                nextScreen: const LoginAgent(title: 'Agent Login'),
              ),
              // const SizedBox(height: 40),
              // Image.asset('assets/images/logo/saapp_icon.png', scale: 1),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ContinueScreenButtons {
  static ElevatedButton continueScreenButton(
      {required IconData particularIcon,
      required String buttonText,
      required BuildContext theContext,
      required Widget nextScreen}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(300, 50),
        maximumSize: const Size(400, 50),
        backgroundColor: Colors.blue,
      ),
      icon: Icon(
        particularIcon,
        size: 24.0,
      ),
      label: Text(buttonText,
          style: GoogleFonts.rubik(
            textStyle: const TextStyle(
                color: Colors.white, letterSpacing: .5, fontSize: 27),
          )),
      onPressed: () {
        Navigator.push(
          theContext,
          MaterialPageRoute(builder: (context) {
            return nextScreen;
          }),
        );
      }, // <-- Text
    );
  }
}
