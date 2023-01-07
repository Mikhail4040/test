import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task/controller/muController.dart';
import 'package:task/styles/textStyle.dart';
import 'package:task/view/screens/homePage.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  var formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool isPassVis = false;
  String matchingPassword="";
  MyController myController = Get.put(MyController());

  void submit() async {
    var ok = formKey.currentState?.validate();
    //  await myController.getUsers();
    if (ok!) {
      formKey.currentState?.save();
      var prefs = await SharedPreferences.getInstance();
      int indexOfUser =
          myController.users.indexWhere((element) => element.email == email.toString());
      print("index is $indexOfUser");
      if (indexOfUser >= 0) {
        int userId = myController.users[indexOfUser].id;
        await prefs.setInt("isExist", userId);
        print(prefs.getInt("isExist"));
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          return HomePage(userId: userId);
        }));
      }
    }
  }

  void init() async {
    await myController.getUsers();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  bool check(String email) {
    bool isExist = false;
    myController.getUsers();
    print(email);
    myController.users.forEach((element) {
      if (element.email.toString() == email.toString()) {
        setState(() {
          isExist = true;
          matchingPassword = element.password;
        });
      }
    });
    print(isExist);
    return isExist ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Image.asset(
                  'assets/images/image1.png',
                  width: 100,
                  height: 100,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Login",
                  style: MyTextStyle.AlexandriaFLF_Bold,
                ),
                SizedBox(
                  height: 165,
                ),
                Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildEmailFormField(),
                        SizedBox(
                          height: 25,
                        ),
                        buildPassTextFormField(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 38,
                ),
                buildElevatedButton(),
                SizedBox(
                  height: 190,
                ),
                buildRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Dont have an account?",
          style: TextStyle(
              fontFamily: "AlexandriaFLF-Italic", color: Colors.deepPurple),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/register');
          },
          child: Text(
            " Register",
            style: TextStyle(
                fontFamily: 'AlexandriaFLF-Bold',
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple),
          ),
        ),
      ],
    );
  }

  Container buildEmailFormField() {
    return Container(
      margin: EdgeInsets.only(left: 60, right: 60),
      child: TextFormField(
        textAlign: TextAlign.center,
        key: ValueKey("email"),
        validator: (val) {
          bool isExist = check(val.toString());
          if (val!.isEmpty || !val.contains('@')) {
            return "Invalid email";
          }
          if (!isExist) return "Email not found";
          return null;
        },
        onSaved: (val) => email = val!,
        decoration: InputDecoration(
            hintText: "Email Address",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black26,
              ),
            ),
            hintStyle: TextStyle(fontFamily: "AlexandriaFLF-Bold")

            //  labelStyle: Style.labelStyle
            ),
      ),
    );
  }

  Container buildPassTextFormField() {
    return Container(
      margin: EdgeInsets.only(left: 60, right: 60),
      child: TextFormField(
        textAlign: TextAlign.center,
        key: ValueKey("Password"),
        validator: (val) {
          if (val!.isEmpty || val.length < 7) {
            return "Wrong password";
          }
          if (val.toString() != matchingPassword.toString()) {
            // print(val);
            // print(matchingPassword);
            return "Incorrect password";
          }
          return null;
        },
        onSaved: (val) => password = val.toString(),
        obscureText: !isPassVis ? true : false,
        decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isPassVis = !isPassVis;
                });
              },
              icon: Icon(!isPassVis ? Icons.visibility : Icons.visibility_off),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black26,
              ),
            ),
            hintText: "password",
            hintStyle: TextStyle(fontFamily: "AlexandriaFLF-Bold")),
      ),
    );
  }

  ElevatedButton buildElevatedButton() {
    return ElevatedButton(
        onPressed: () {
          submit();
        },
        child: Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(Size(180, 40)),
          backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
        ));
  }
}
