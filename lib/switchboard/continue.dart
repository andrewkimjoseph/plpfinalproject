import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saapp/agent/home.dart';
import 'package:saapp/switchboard/continue_test.dart';
import 'package:saapp/switchboard/policy_dialog.dart';
import '../agent/login.dart';
import '../client/login.dart';
import '../admin/login.dart';
import '../main.dart';
import 'package:flutter/gestures.dart';

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
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/splash/splash_screen.png', scale: 1),
              const SizedBox(height: 25),
              TextLabels.thickMontserrat('CONTINUE AS:', 25),
              const SizedBox(height: 25),
              ContinueScreenWidgets.continueScreenButton(
                  particularIcon: Icons.manage_accounts,
                  theContext: context,
                  buttonText: "ADMIN",
                  nextScreen: const LoginSAApp(
                    title: 'Admin Login',
                  ),
                  color: Colors.blue),
              const SizedBox(height: 20),
              ContinueScreenWidgets.continueScreenButton(
                  particularIcon: Icons.admin_panel_settings,
                  theContext: context,
                  buttonText: "CLIENT",
                  nextScreen: const LoginClient(title: 'Client Login'),
                  color: Colors.blue),
              const SizedBox(height: 20),
              ContinueScreenWidgets.continueScreenButton(
                  particularIcon: Icons.person_pin,
                  theContext: context,
                  buttonText: "AGENT",
                  nextScreen: const LoginAgent(title: 'Agent Login'),
                  color: Colors.blue),
              const SizedBox(height: 20),
              ContinueScreenWidgets.continueScreenButton(
                  particularIcon: Icons.mode,
                  theContext: context,
                  buttonText: "TEST MODE",
                  nextScreen:
                      const ContinueTest(title: 'Version 1.0 [TEST MODE]'),
                  color:
                      BuildMaterialColorGenerator.buildMaterialColorGenerator(
                          const Color(0xFF2b334b))),
              const SizedBox(height: 25),
              ContinueScreenWidgets.privacyPolicyLinkAndTermsOfService(
                  theContext: context)
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ContinueScreenWidgets {
  static ElevatedButton continueScreenButton(
      {required IconData particularIcon,
      required String buttonText,
      required BuildContext theContext,
      required Widget nextScreen,
      required Color color}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(300, 50),
        maximumSize: const Size(400, 50),
        backgroundColor: color,
      ),
      icon: Icon(
        particularIcon,
        size: 24.0,
      ),
      label: Text(buttonText,
          style: GoogleFonts.rubik(
            textStyle: const TextStyle(
                color: Colors.white, letterSpacing: .5, fontSize: 25),
          )),
      onPressed: () {
        nextScreen;
        Navigator.push(
          theContext,
          MaterialPageRoute(builder: (context) {
            return nextScreen;
          }),
        );
      }, // <-- Text
    );
  }

  static Widget privacyPolicyLinkAndTermsOfService(
      {required BuildContext theContext}) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: Center(
          child: Text.rich(TextSpan(
              text: 'By continuing, you agree to our ',
              style: const TextStyle(fontSize: 15, color: Colors.black),
              children: <TextSpan>[
            TextSpan(
                text: 'Terms of Service',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showDialog(
                      context: theContext,
                      builder: (context) {
                        return PolicyDialog(
                          mdFileName: 'terms_and_conditions.md',
                        );
                      },
                    );
                  }),
            TextSpan(
                text: ' and ',
                style: const TextStyle(fontSize: 15, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Privacy Policy',
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          showDialog(
                            context: theContext,
                            builder: (context) {
                              return PolicyDialog(
                                mdFileName: 'privacy_policy.md',
                              );
                            },
                          );
                          // code to open / launch privacy policy link here
                        })
                ])
          ]))),
    );
  }
}
