import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saapp/agent/home.dart';
import '../client/home.dart';
import '../main.dart';

// THIS IS THE SWITCHBOARD THAT ESTABLISHES THE ROUTE A USER TAKES
class ContinueTest extends StatefulWidget {
  const ContinueTest({super.key, required this.title});
  final String title;

  @override
  State<ContinueTest> createState() => _ContinueTest();
}

class _ContinueTest extends State<ContinueTest> {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Image.asset('assets/images/test_mode_cover.png', scale: 1),
            const SizedBox(height: 25),
            TextLabels.thickMontserrat('CONTINUE AS:', 25),
            const SizedBox(height: 25),
            ContinueScreenButtons.continueScreenButton(
              particularIcon: Icons.admin_panel_settings,
              theContext: context,
              buttonText: "CLIENT",
              nextScreen: const HomeClient(clientId: 'creditouch_001'),
            ),
            const SizedBox(height: 20),
            ContinueScreenButtons.continueScreenButton(
              particularIcon: Icons.person_pin,
              theContext: context,
              buttonText: "AGENT",
              nextScreen: const HomeAgent(
                  agentId: 'pcl_001',
                  clientId: 'creditouch_001',
                  fetchedRefCount: 4),
            ),
            const SizedBox(height: 100),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(300, 50),
                maximumSize: const Size(400, 50),
                backgroundColor:
                    BuildMaterialColorGenerator.buildMaterialColorGenerator(
                        const Color(0xFF2b334b)),
              ),
              icon: const Icon(
                Icons.arrow_back,
                size: 24.0,
              ),
              label: Text('GO BACK',
                  style: GoogleFonts.rubik(
                    textStyle: const TextStyle(
                        color: Colors.white, letterSpacing: .5, fontSize: 25),
                  )),
              onPressed: () {
                Navigator.pop(
                  context,
                );
              }, // <-- Text
            )
          ],
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
                color: Colors.white, letterSpacing: .5, fontSize: 25),
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
