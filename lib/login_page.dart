import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_track/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_track/signup_page.dart';

class LoginApi extends StatefulWidget {
  const LoginApi({Key? key}) : super(key: key);

  @override
  State<LoginApi> createState() => _LoginApiState();
}

class _LoginApiState extends State<LoginApi> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool processRun = false;
  bool tapPass = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset("assets/images/Sky_Blue_Wallpaper.jpeg",
                height: double.infinity,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill),
            SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0, top: 5),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePageApi(),
                                ),
                                    (route) => false);
                          },
                          child: const Text(
                            "Skip",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: Text(
                          "TASK APP",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Audiowide",
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 70,
                      ),
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 40, left: 25),
                        child: Text(
                          "Username",
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, right: 20, left: 20, bottom: 15),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter username";
                          }
                        },
                        controller: userController,
                        keyboardType: TextInputType.name,
                        style: const TextStyle(
                            color: Color(0xff103C78),
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                const BorderSide(color: Color(0xff103C78)),
                                borderRadius: BorderRadius.circular(35)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color(0xffE4E4E4)
                                        .withOpacity(0.60)),
                                borderRadius: BorderRadius.circular(35)),
                            hintText: " please enter username",
                            hintStyle: const TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            )),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 25),
                        child: Text(
                          "Password",
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 10.0, left: 20, right: 20),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter password";
                          } else if (!RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                              .hasMatch(value)) {
                            return "enter valid password\npassword length must be 8 char\nMinimum 1 Upper case\nMinimum 1 lowercase\nMinimum 1 Numeric Number\nMinimum 1 Special Character\nCommon Allow Character ( ! @ # \$ & * ~ )";
                          }
                        },
                        controller: passController,
                        obscureText: tapPass==true?
                        true:false,
                        keyboardType: TextInputType.visiblePassword,
                        onFieldSubmitted: (value) => print(value),
                        style: const TextStyle(
                            color: Color(0xff103C78),
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xff06172d)),
                                borderRadius: BorderRadius.circular(35)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffE4E4E4).withOpacity(0.60)),
                                borderRadius: BorderRadius.circular(35)),
                            hintText: "please enter password",
                            hintStyle: const TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                tapPass = !tapPass;
                                setState(() {});
                              },
                              child: tapPass == true
                                  ? Icon(Icons.remove_red_eye)
                                  : Icon(Icons.remove_red_eye_outlined),
                            )),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(
                          left: 100, right: 100, top: 70, bottom: 20),
                      padding: const EdgeInsets.only(top: 15, bottom: 13),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [
                          Color(0xff447CB7),
                          Color(0xff447CB7),
                          Color(0xff89C2FE),
                          Color(0xff447CB7)
                        ]),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Center(
                        child: InkWell(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              processRun = true;
                              setState(() {});
                              http.Response response = await http.post(
                                  Uri.parse(
                                      "https://todo-list-app-kpdw.onrender.com/api/auth/signin"),
                                  body: {
                                    "username": userController.text,
                                    "password": passController.text
                                  });
                              print("Status Code = ${response.statusCode}");
                              print("Body = ${response.body}");
                              print(
                                  "Body = ${jsonDecode(response.body)['accessToken']}");

                              processRun = false;
                              setState(() {});

                              if (response.statusCode == 200) {
                                print(" Login Successfully");
                                final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                                prefs.setString("token",
                                    "${jsonDecode(response.body)['accessToken']}");
                                Fluttertoast.showToast(
                                    msg: "Login Successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: const Color(0xff5D5BDD),
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePageApi(),
                                  ),
                                      (route) => false,
                                );
                              } else {
                                print(
                                    "Body = ${jsonDecode(response.body)['message']}");
                                Fluttertoast.showToast(
                                    msg:
                                    "${jsonDecode(response.body)['message']}",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: const Color(0xff5D5BDD),
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            }
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                                text: "Sign up",
                                style: const TextStyle(
                                  color: Color(0xff006F57),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SignupAPi(),
                                        ));
                                  })
                          ]),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
