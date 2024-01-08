import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';
import 'login_page.dart';


class SplashScreenApi extends StatefulWidget {
  const SplashScreenApi({Key? key}) : super(key: key);

  @override
  State<SplashScreenApi> createState() => _SplashScreenApiState();
}

class _SplashScreenApiState extends State<SplashScreenApi> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setRouting();
  }

  setRouting() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    debugPrint("token:$token");
    Future.delayed(
      const Duration(seconds: 3),
          () {
        if (token == null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginApi(),
              ),
                  (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePageApi(),
              ),
                  (route) => false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset("assets/images/Sky_Blue_Wallpaper.jpeg",
              height: double.infinity,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 85,
                  width: 85,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xff103C78),
                            blurRadius: 5,
                            offset: Offset(5, 5))
                      ],
                      image: DecorationImage(
                          image: AssetImage(
                            "assets/images/blue q.jpeg",
                          ),
                          fit: BoxFit.fill)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "TASK APP",
                style: TextStyle(
                  color: Color(0xff103C78),
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Audiowide",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
