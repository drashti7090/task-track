import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class HomePageApi extends StatefulWidget {
  const HomePageApi({Key? key}) : super(key: key);

  @override
  State<HomePageApi> createState() => _HomePageApiState();
}

class _HomePageApiState extends State<HomePageApi> {
  final formKey = GlobalKey<FormState>();
  TextEditingController taskName = TextEditingController();
  int? id;
  List getData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApi();
    //setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
          backgroundColor: const Color(0xff467BB9),
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Text("All", style: TextStyle(color: Colors.white54)),
                Text("Pending", style: TextStyle(color: Colors.white54)),
                Text("Completed", style: TextStyle(color: Colors.white54)),
              ],
            ),
            backgroundColor: const Color(0xff103C78),
            elevation: 15,
            actions: [
              OutlinedButton(
                  onPressed: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("LogOut"),
                          content: const Text("Are you sure want to logout?"),
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  final SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.clear();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginApi(),
                                      ),
                                      (route) => false);
                                },
                                child: const Text("Yes")),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("No")),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ))
            ],
            title: const Text("Home Page",
                style: TextStyle(color: Colors.white54)),
            centerTitle: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
          ),
          body: Stack(children: [
            Image.asset("assets/images/Sky_Blue_Wallpaper.jpeg",
                height: double.infinity,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill),
            TabBarView(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(
                      bottom: 20.0, top: 20, left: 20, right: 20),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: getData.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      endActionPane:
                          ActionPane(motion: const ScrollMotion(), children: [
                        SlidableAction(
                          onPressed: (context) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                      "are you sure you want to delete?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        deleteApi();
                                        id = getData[index]['id'];
                                        Navigator.pop(context);
                                      },
                                      child: const Text("yes"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                      child: const Text("no"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          backgroundColor: const Color(0xff103C78),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ]),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        height: 70,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: getData[index]["status"] == true
                              ? const Color(0xff103C78)
                              : Colors.blueGrey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
                            GestureDetector(
                                onTap: () {
                                  getData[index]['status'] == true
                                      ? const SizedBox()
                                      : showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text("Complete"),
                                              content: const Text(
                                                  "Are you sure want to complete the task?"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      id = getData[index]['id'];
                                                      putApi();
                                                      setState(() {});
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Yes")),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("No"))
                                              ],
                                            );
                                          });
                                  setState(() {});
                                },
                                child: getData[index]['status'] == true
                                    ? const Icon(
                                        Icons.check_box,
                                        color: Colors.white,
                                        size: 35,
                                      )
                                    : const Icon(
                                        Icons.check_box_outline_blank,
                                        size: 35,
                                      )),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${getData[index]["description"]}",
                              style: TextStyle(
                                  fontSize: 12.8,
                                  color: getData[index]["status"] == true
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                      bottom: 20.0, top: 20, left: 20, right: 20),
                  itemCount: getData.length,
                  itemBuilder: (context, index) {
                    return getData[index]["status"] == false
                        ? Slidable(
                            endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                "are you sure you want to delete?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  id = getData[index]['id'];
                                                  deleteApi();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("yes"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("no"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    backgroundColor: const Color(0xff103C78),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ]),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),
                              height: 70,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: getData[index]["status"] == true
                                    ? const Color(0xff103C78)
                                    : Colors.blueGrey,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        id = getData[index]['id'];
                                        getData[index]['status'] == true
                                            ? const SizedBox()
                                            : showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title:
                                                        const Text("Complete"),
                                                    content: const Text(
                                                        "Are you sure want to complete the task?"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            putApi();
                                                            setState(() {});

                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              "Yes")),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              const Text("No"))
                                                    ],
                                                  );
                                                });
                                        setState(() {});
                                      },
                                      child: getData[index]['status'] == true
                                          ? const Icon(
                                              Icons.check_box,
                                              color: Colors.white,
                                              size: 35,
                                            )
                                          : const Icon(
                                              Icons.check_box_outline_blank,
                                              size: 35,
                                            )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${getData[index]["description"]}",
                                    style: TextStyle(
                                        fontSize: 12.8,
                                        color: getData[index]["status"] == true
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox();
                  },
                ),
                ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(
                      bottom: 20.0, top: 20, left: 20, right: 20),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: getData.length,
                  itemBuilder: (context, index) {
                    return getData[index]["status"] == true
                        ? Slidable(
                            endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                "are you sure you want to delete?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  id = getData[index]['id'];
                                                  deleteApi();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("yes"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("no"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    backgroundColor: const Color(0xff103C78),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ]),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),
                              height: 70,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: getData[index]["status"] == true
                                    ? const Color(0xff103C78)
                                    : Colors.blueGrey,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        id = getData[index]['id'];
                                        getData[index]['status'] == true
                                            ? const SizedBox()
                                            : showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title:
                                                        const Text("Complete"),
                                                    content: const Text(
                                                        "Are you sure want to complete the task?"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            putApi();
                                                            setState(() {});

                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              "Yes")),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              const Text("No"))
                                                    ],
                                                  );
                                                });
                                        setState(() {});
                                      },
                                      child: getData[index]['status'] == true
                                          ? const Icon(
                                              Icons.check_box,
                                              color: Colors.white,
                                              size: 35,
                                            )
                                          : const Icon(
                                              Icons.check_box_outline_blank,
                                              size: 35,
                                            )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${getData[index]["description"]}",
                                    style: TextStyle(
                                        fontSize: 12.8,
                                        color: getData[index]["status"] == true
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox();
                  },
                ),
              ],
            )
          ]),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                taskName.clear();
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Task",
                          style: TextStyle(color: Color(0xff103C78))),
                      backgroundColor:
                          const Color(0xff89C2FE).withOpacity(0.90),
                      content: Form(
                        key: formKey,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter name";
                            }
                            return null;
                          },
                          controller: taskName,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                              color: Color(0xff103C78),
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xff103C78)),
                                  borderRadius: BorderRadius.circular(35)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xff103C78)
                                          .withOpacity(0.60)),
                                  borderRadius: BorderRadius.circular(35)),
                              hintText: " please enter task name",
                              hintStyle: const TextStyle(
                                color: Color(0xff103C78),
                                fontWeight: FontWeight.w300,
                                fontSize: 13,
                              )),
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                postApi();
                                setState(() {});
                                Navigator.pop(context);
                              }
                              //setState(() {});
                            },
                            child: const Text(
                              "Add",
                              style: TextStyle(color: Color(0xff103C78)),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Exit",
                                style: TextStyle(color: Color(0xff103C78))))
                      ],
                    );
                  },
                );
              },
              backgroundColor: const Color(0xff103C78),
              elevation: 20,
              child: const Icon(Icons.add, color: Colors.white54)),
        ),
      ),
    );
  }

  void deleteApi() async {
    setState(() {});

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    http.Response response = await http.delete(
        Uri.parse("https://todo-list-app-kpdw.onrender.com/api/tasks/$id"),
        headers: {"x-access-token": "$token"});
    if (response.statusCode == 200) {
      getApi();
      Fluttertoast.showToast(
          msg: "${jsonDecode(response.body)['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.indigo,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "${jsonDecode(response.body)['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.indigo,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void getApi() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    http.Response response = await http.get(
        Uri.parse("https://todo-list-app-kpdw.onrender.com/api/tasks"),
        headers: {"x-access-token": "$token"});
    getData = jsonDecode(response.body);
    if (response.statusCode == 200) {
    } else if (response.statusCode == 401) {
      prefs.clear();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginApi(),
          ));
    } else {
      Fluttertoast.showToast(
          msg: "${jsonDecode(response.body)['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.indigo,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void postApi() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    http.Response response = await http.post(
        Uri.parse("https://todo-list-app-kpdw.onrender.com/api/tasks"),
        body: {"description": taskName.text, "status": "false"},
        headers: {"x-access-token": "$token"});
    debugPrint("Status Code = ${response.statusCode}");
    debugPrint("Body = ${response.body}");
    if (response.statusCode == 200) {
      getApi();
      Fluttertoast.showToast(
          msg: "Add data successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      debugPrint("Body = ${jsonDecode(response.body)['message']}");
      Fluttertoast.showToast(
          msg: "${jsonDecode(response.body)['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void putApi() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    http.Response response = await http.put(
        Uri.parse("https://todo-list-app-kpdw.onrender.com/api/tasks/$id"),
        body: {
          // "description": "${getData[i]['description']}",
          "status": "true"
        },
        headers: {
          "x-access-token": "$token"
        });
    if (response.statusCode == 200) {
      //print("Successfully");
      getApi();
      Fluttertoast.showToast(
          msg: "${jsonDecode(response.body)['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.indigo,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "${jsonDecode(response.body)['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.indigo,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
