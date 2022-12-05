// import 'package:courseapplandingpage/home.dart';
import 'onboard_model.dart';
import 'package:flutter/material.dart';
import 'package:saapp/switchboard/continue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constant.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  late PageController _pageController;
  List<OnboardModel> screens = <OnboardModel>[
    OnboardModel(
      img: 'assets/images/onboarding/onboarding-0.png',
      text: 'Welcome to CrediTouch! 🤝',
      desc:
          "Here, you engage prospective borrowers to convert them by personalizing their experience and sharing their data safely.",
      bg: Colors.white,
      button: const Color(0xFF4756DF),
    ),
    OnboardModel(
      img: 'assets/images/onboarding/onboarding-1.gif',
      text: "Agent Handling and Progress Tracking",
      desc:
          "After the Admin onboards the Client, they onboard the Agent and monitors their progress.\n\nThe Client also receives real-time data of the Referral (prospective borrower).",
      bg: const Color(0xFF4756DF),
      button: Colors.white,
    ),
    OnboardModel(
      img: 'assets/images/onboarding/onboarding-2.gif',
      text: "Data Handling for Prospective Borrowers",
      desc:
          "Finally, the Agent shares prospective borrower data from the ground, and generates personalized loan repayment schedules for the Referral.",
      bg: Colors.white,
      button: const Color(0xFF4756DF),
    ),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _storeOnboardInfo() async {
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentIndex % 2 == 0 ? kwhite : kblue,
      appBar: AppBar(
        backgroundColor: currentIndex % 2 == 0 ? kwhite : kblue,
        elevation: 0.0,
        actions: [
          TextButton(
            onPressed: () {
              _storeOnboardInfo();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Continue(
                            title: 'Version 1.0',
                          )));
            },
            child: Text(
              "Skip",
              style: TextStyle(
                color: currentIndex % 2 == 0 ? kblack : kwhite,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: PageView.builder(
            itemCount: screens.length,
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (_, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(screens[index].img),
                  SizedBox(
                    height: 10.0,
                    child: ListView.builder(
                      itemCount: screens.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3.0),
                                width: currentIndex == index ? 25 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: currentIndex == index
                                      ? kbrown
                                      : kbrown300,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ]);
                      },
                    ),
                  ),
                  Text(
                    screens[index].text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 27.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: index % 2 == 0 ? kblack : kwhite,
                    ),
                  ),
                  Text(
                    screens[index].desc,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Montserrat',
                      color: index % 2 == 0 ? kblack : kwhite,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (index == screens.length - 1) {
                        await _storeOnboardInfo();
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Continue(
                                      title: 'Version 1.0',
                                    )));
                      }
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10),
                      decoration: BoxDecoration(
                          color: index % 2 == 0 ? kblue : kwhite,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(
                          "Next",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: index % 2 == 0 ? kwhite : kblue),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        Icon(
                          Icons.arrow_forward_sharp,
                          color: index % 2 == 0 ? kwhite : kblue,
                        )
                      ]),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
