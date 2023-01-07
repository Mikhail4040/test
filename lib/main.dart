import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/controller/muController.dart';
import 'package:task/view/screens/homePage.dart';
import 'package:task/view/screens/logIn.dart';
import 'package:task/view/screens/register.dart';
import 'package:task/view/screens/welcome.dart';
import 'model/dp.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isExist = false;
  int? id;

  void init() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("isExist")! > 0) {
      setState(() {
        id = prefs.getInt("isExist");
        isExist = true;
      });
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(id);
    // print(isExist);

    // int index= myController.users.indexWhere((element) => element.id == id);
    // print(myController.users[index].email);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/register': (context) => Register(),
        '/logIn': (context) => LogIn(),
      },
      home: isExist ? HomePage(userId: id!) : Welcome(),
    );
  }
}
