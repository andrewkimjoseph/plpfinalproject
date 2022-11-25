import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
              image: AssetImage("assets/images/ocean-bg.jpg"),
              fit: BoxFit.cover),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Image.asset('assets/images/saapp_icon.png', scale: 7),
                const SizedBox(height: 25),
                Text('Continue As\n⬇️',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                          color: Colors.white,
                          backgroundColor: Colors.blue,
                          letterSpacing: .5,
                          fontSize: 35,
                          fontWeight: FontWeight.w700),
                    )),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const LoginSAApp(title: 'Admin Login')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(300, 50),
                    maximumSize: const Size(400, 50),
                  ),
                  child: Text('ADMIN 👩‍💻',
                      style: GoogleFonts.rubik(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            letterSpacing: .5,
                            fontSize: 35),
                      )),
                ),
                const SizedBox(height: 35),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const LoginClient(title: 'Client Login')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 50),
                      maximumSize: const Size(400, 50),
                    ),
                    child: Text('CLIENT 💼',
                        style: GoogleFonts.rubik(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              letterSpacing: .5,
                              fontSize: 35),
                        ))),
                const SizedBox(height: 35),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const LoginAgent(title: 'Agent Login')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 50),
                      maximumSize: const Size(400, 50),
                    ),
                    child: Text('AGENT 🗂️',
                        style: GoogleFonts.rubik(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              letterSpacing: .5,
                              fontSize: 35),
                        ))),
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
