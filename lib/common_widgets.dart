import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

void getUserDataAPI({Function? setState}) async {
  http.Response response = await http.get(Uri.parse(""));
  userList = jsonDecode(response.body)["data"];
  setState!;
  print(userList);
}

List userList = [];

void showMassage({required String msg}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      fontSize: 16.0);
}
