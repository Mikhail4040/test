import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/controller/muController.dart';
import 'package:task/styles/textStyle.dart';
import 'package:task/view/screens/changePasswordPage.dart';
import 'package:task/view/screens/logIn.dart';
import 'package:task/view/screens/updatePage.dart';
import 'package:task/view/screens/welcome.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.userId}) : super(key: key);
  int userId;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? name;
  int? phoneNumber;
  String? email;

  MyController myController = Get.put(MyController());

  void init() async {
    await myController.getUsers();
    int indexOfUser =
        myController.users.indexWhere((element) => element.id == widget.userId);
    var userInfo = myController.users[indexOfUser];
    setState(() {
      name = userInfo.name;
      phoneNumber = userInfo.phone;

      email = userInfo.email;
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  init();
    String realNumber = "";
    String countryCode = "";
    String Number = phoneNumber.toString();
    Number = Number.split('').reversed.join('');
    realNumber = Number.substring(0, 9);
    countryCode = Number.substring(9);
    realNumber = realNumber.split('').reversed.join('');
    countryCode = countryCode.split('').reversed.join('');
    countryCode = '+' + countryCode;
    realNumber = ' ' + realNumber;
    countryCode += realNumber;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade900,
        title: Center(
          child: Text("Home Page", style: MyTextStyle.myFont),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              buildListTile(name!, Icons.perm_identity),
              buildListTile(countryCode.toString(), Icons.phone_android),
              buildListTile(email.toString(), Icons.mail_outline),
              buildCard("Update Information", Icons.arrow_forward_ios_outlined,
                  () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return UpdatePage(userId: widget.userId);
                })).then((value) {
                  if (value)
                    Get.snackbar(
                      "Success",
                      "Your information is update successfully",
                      snackPosition: SnackPosition.BOTTOM,
                      colorText: Colors.white,
                      backgroundColor: Colors.green.shade300,
                    );
                  setState(() async {
                    init();
                  });
                });
              }),
              buildCard("Change Password", Icons.arrow_forward_ios_outlined,
                  () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ChangePasswordPage(
                    userId: widget.userId,
                  );
                })).then((value) {
                  if (value)
                    Get.snackbar(
                      "Success",
                      "Your Password is update successfully",
                      snackPosition: SnackPosition.BOTTOM,
                      colorText: Colors.white,
                      backgroundColor: Colors.green.shade300,
                    );
                });
              }),
              buildCard("Delete Account", Icons.arrow_forward_ios_outlined,
                  () async {
                await myController.DeleteUser(widget.userId);
                var prefs = await SharedPreferences.getInstance();
                prefs.remove("isExist");
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (_) {
                  return Welcome();
                }));
              }),
              buildCard("Logout", Icons.arrow_forward_ios_outlined, () async {
                var prefs = await SharedPreferences.getInstance();
                prefs.remove("isExist");
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (_) {
                  return Welcome();
                }));
              }),
            ],
          ),
        ),
      ),
    );
  }

  Card buildCard(String title, IconData icon, Function onTap) {
    return Card(
      elevation: 1,
      child: ListTile(
        onTap: () {
          onTap();
        },
        title: Text(
          title,
          style: MyTextStyle.AlexandriaFLF_Bold,
        ),
        trailing: Icon(
          icon,
          color: Colors.deepPurple.shade900,
        ),
      ),
    );
  }

  ListTile buildListTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.deepPurple.shade900,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black26,
        ),
      ),
    );
  }
}
