import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_track/login_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool put = false;
  bool post = false;
  bool get = false;
  bool delete = false;
  int? id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApi();
  }

  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  List getData = [];

  @override
  Widget build(BuildContext context) {
    debugPrint("List = $getData");
    debugPrint("Length = ${getData.length}");
    return DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xff5D5BDD),
              onPressed: () {
                name.clear();
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Task"),
                      content: Form(
                        key: formKey,
                        child: TextFormField(
                            controller: name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enter name";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                hintText: "Enter task name",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:
                                        const BorderSide(color: Colors.blue)))),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                /* taskList.add({
                                                "task_name": "${name.text}",
                                                "select": "false"
                                              });
                                              */
                                postApi();
                                setState(() {});
                                Navigator.pop(context);
                              }
                              //setState(() {});
                            },
                            child: const Text("Add")),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Exit"))
                      ],
                    );
                  },
                );
              },
              child: const Icon(Icons.add)),
          body: Column(
            children: [
              Container(
                height: 116,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.bottomLeft,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    Color(0xff3531D5),
                    Color(0xff5D5BDD),
                    Color(0xff6A66DA),
                  ],
                )),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        OutlinedButton(
                            onPressed: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("LogOut"),
                                    content: const Text(
                                        "Are you sure want to logout?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            final SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.clear();
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginApi(),
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
                              "LogOut",
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                    const TabBar(
                      tabs: [
                        Tab(
                          child: Text(
                            "All",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        Tab(
                          child: Text("Pending",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                        Tab(
                          child: Text("Completed",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    ListView.builder(
                        //shrinkWrap: true,
                        itemCount: getData.length,
                        itemBuilder: (BuildContext context, index) {
                          //debugPrint("ItemCount = ${getData.length}");
                          return Slidable(
                            endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      //getApi();
                                      /*debugPrint("List = $getData");*/
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Delete"),
                                            content: const Text(
                                                "Are you sure want to delete task?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    /*taskList
                                                        .removeAt(index);*/
                                                    id = getData[index]['id'];
                                                    debugPrint("$id");

                                                    deleteApi();
                                                    //getApi();
                                                    setState(() {});
                                                    Navigator.pop(context);
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
                                    icon: Icons.delete,
                                    label: "Delete",
                                  ),
                                ]),
                            child: Container(
                              height: 120,
                              width: MediaQuery.of(context).size.width - 30,
                              margin: const EdgeInsets.only(
                                  bottom: 15, left: 15, right: 15),
                              decoration: BoxDecoration(
                                  /* color: taskList[index]['select'] == ""true""
                                      ? Color(0xff3531D5)
                                      : Colors.grey.withOpacity(0.5),*/
                                  gradient: LinearGradient(
                                      colors: getData[index]['status'] == true
                                          ? [
                                              const Color(0xff3531D5),
                                              const Color(0xff5D5BDD),
                                              const Color(0xff6A66DA),
                                            ]
                                          : [
                                              Colors.grey.withOpacity(0.5),
                                              Colors.grey.withOpacity(0.5)
                                            ]),
                                  borderRadius: BorderRadius.circular(10)),
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
                                                    title:
                                                        const Text("Complete"),
                                                    content: const Text(
                                                        "Are you sure want to complete the task?"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            /*getData[index][
                                                                    'status'] = "true";*/
                                                            id = getData[index]
                                                                ['id'];
                                                            //i = index;
                                                            putApi();
                                                            //getApi();
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

                                        /*if (taskList[index]['select'] == ""true"") {
                                          select = "true";
                                        }*/
                                        setState(() {});
                                        //debugPrint(taskList[index]);
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
                        }),
                    ListView.builder(
                        //shrinkWrap: true,
                        itemCount: getData.length,
                        itemBuilder: (BuildContext context, index) {
                          return getData[index]['status'] == false
                              ? Slidable(
                                  endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) {
                                            /*getApi();
                                      debugPrint("List = $getData");*/
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text("Delete"),
                                                  content: const Text(
                                                      "Are you sure want to delete task?"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          /*taskList
                                                        .removeAt(index);*/
                                                          id = getData[index]
                                                              ['id'];
                                                          debugPrint("$id");

                                                          deleteApi();
                                                          //getApi();
                                                          setState(() {});
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text("Yes")),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text("No")),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: Icons.delete,
                                          label: "Delete",
                                        ),
                                      ]),
                                  child: Container(
                                    height: 120,
                                    width:
                                        MediaQuery.of(context).size.width - 30,
                                    margin: const EdgeInsets.only(
                                        bottom: 15, left: 15, right: 15),
                                    decoration: BoxDecoration(
                                        /* color: taskList[index]['select'] == ""true""
                                      ? Color(0xff3531D5)
                                      : Colors.grey.withOpacity(0.5),*/
                                        gradient: LinearGradient(
                                            colors: getData[index]['status'] ==
                                                    true
                                                ? [
                                                    const Color(0xff3531D5),
                                                    const Color(0xff5D5BDD),
                                                    const Color(0xff6A66DA),
                                                  ]
                                                : [
                                                    Colors.grey
                                                        .withOpacity(0.5),
                                                    Colors.grey.withOpacity(0.5)
                                                  ]),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              id = getData[index]['id'];
                                              //i = index;
                                              getData[index]['status'] == true
                                                  ? const SizedBox()
                                                  : showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              "Complete"),
                                                          content: const Text(
                                                              "Are you sure want to complete the task?"),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  /*getData[index][
                                                                    'status'] = "true";*/
                                                                  putApi();
                                                                  //getApi();
                                                                  setState(
                                                                      () {});

                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                        "Yes")),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                        "No"))
                                                          ],
                                                        );
                                                      });

                                              /*if (taskList[index]['select'] == ""true"") {
                                          select = "true";
                                        }*/
                                              setState(() {});
                                              //debugPrint(taskList[index]);
                                            },
                                            child:
                                                getData[index]['status'] == true
                                                    ? const Icon(
                                                        Icons.check_box,
                                                        color: Colors.white,
                                                        size: 35,
                                                      )
                                                    : const Icon(
                                                        Icons
                                                            .check_box_outline_blank,
                                                        size: 35,
                                                      )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${getData[index]["description"]}",
                                          style: TextStyle(
                                              fontSize: 12.8,
                                              color: getData[index]["status"] ==
                                                      true
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox();
                        }),
                    ListView.builder(
                        //shrinkWrap: true,
                        itemCount: getData.length,
                        itemBuilder: (BuildContext context, index) {
                          return getData[index]['status'] == true
                              ? Slidable(
                                  endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) {
                                            /*getApi();
                                      debugPrint("List = $getData");*/
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text("Delete"),
                                                  content: const Text(
                                                      "Are you sure want to delete task?"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          /*taskList
                                                        .removeAt(index);*/
                                                          id = getData[index]
                                                              ['id'];
                                                          debugPrint("$id");

                                                          deleteApi();
                                                          setState(() {});
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text("Yes")),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text("No")),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: Icons.delete,
                                          label: "Delete",
                                        ),
                                      ]),
                                  child: Container(
                                    height: 120,
                                    width:
                                        MediaQuery.of(context).size.width - 30,
                                    margin: const EdgeInsets.only(
                                        bottom: 15, left: 15, right: 15),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: getData[index]['status'] ==
                                                    true
                                                ? [
                                                    const Color(0xff3531D5),
                                                    const Color(0xff5D5BDD),
                                                    const Color(0xff6A66DA),
                                                  ]
                                                : [
                                                    Colors.grey
                                                        .withOpacity(0.5),
                                                    Colors.grey.withOpacity(0.5)
                                                  ]),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              id = getData[index]['id'];
                                              //i = index;
                                              getData[index]['status'] == true
                                                  ? const SizedBox()
                                                  : showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              "Complete"),
                                                          content: const Text(
                                                              "Are you sure want to complete the task?"),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  /*getData[index][
                                                                    'status'] = "true";*/
                                                                  putApi();
                                                                  //getApi();
                                                                  setState(
                                                                      () {});

                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                        "Yes")),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                        "No"))
                                                          ],
                                                        );
                                                      });

                                              /*if (taskList[index]['select'] == ""true"") {
                                          select = "true";
                                        }*/
                                              setState(() {});
                                              //debugPrint(taskList[index]);
                                            },
                                            child:
                                                getData[index]['status'] == true
                                                    ? const Icon(
                                                        Icons.check_box,
                                                        color: Colors.white,
                                                        size: 35,
                                                      )
                                                    : const Icon(
                                                        Icons
                                                            .check_box_outline_blank,
                                                        size: 35,
                                                      )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${getData[index]["description"]}",
                                          style: TextStyle(
                                              fontSize: 12.8,
                                              color: getData[index]["status"] ==
                                                      true
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox();
                        }),
                    //Container(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void getApi() async {
    get = true;
    //showDialog1(context: context);
    setState(() {});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    http.Response response = await http.get(
        Uri.parse("https://todo-list-app-kpdw.onrender.com/api/tasks"),
        headers: {"x-access-token": "$token"});
    debugPrint("Status Code = ${response.statusCode}");
    debugPrint("Body = ${response.body}");
    debugPrint("Body = ${jsonDecode(response.body)}");
    getData = jsonDecode(response.body);

    get = false;
    post = false;
    put = false;
    delete = false;
    //hideDialog1(context);
    setState(() {});

    if (response.statusCode == 200) {
      //debugPrint("Successfully");
      Fluttertoast.showToast(
          msg: "Get data successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (response.statusCode == 401) {
      prefs.clear();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginApi(),
          ));
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

  void postApi() async {
    post = true;
    setState(() {});

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    http.Response response = await http.post(
        Uri.parse("https://todo-list-app-kpdw.onrender.com/api/tasks"),
        body: {"description": name.text, "status": "false"},
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
    put = true;
    //showDialog1(context: context);
    setState(() {});

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
    debugPrint("Status Code = ${response.statusCode}");
    debugPrint("Body = ${response.body}");
    //debugPrint("Body = ${jsonDecode(response.body)['x-access-token']}");

    // put = false;
    //hideDialog1(context);
    //setState(() {});

    if (response.statusCode == 200) {
      //debugPrint("Successfully");
      getApi();
      Fluttertoast.showToast(
          msg: "${jsonDecode(response.body)['message']}",
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

  void deleteApi() async {
    delete = true;
    //showDialog1(context: context);
    setState(() {});

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    http.Response response = await http.delete(
        Uri.parse("https://todo-list-app-kpdw.onrender.com/api/tasks/$id"),
        headers: {"x-access-token": "$token"});
    debugPrint("Status Code = ${response.statusCode}");
    debugPrint("Body = ${response.body}");
    //debugPrint("Body = ${jsonDecode(response.body)['x-access-token']}");

    //delete = false;
    //hideDialog1(context);
    //setState(() {});

    if (response.statusCode == 200) {
      //debugPrint("Successfully");
      getApi();
      Fluttertoast.showToast(
          msg: "${jsonDecode(response.body)['message']}",
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
}
