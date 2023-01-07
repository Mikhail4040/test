import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task/controller/muController.dart';
import 'package:task/styles/textStyle.dart';

import 'package:country_picker/country_picker.dart';
import 'package:task/view/widgets/button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/userInfo.dart';
import 'homePage.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var formKey = GlobalKey<FormState>();
  String fullName = "";
  String phoneNumber = "";
  String email = "";
  String password = "";
  String confirmPassword = "";
  String phoneCode = "971";
  String nameCode = "";

  TextEditingController passwordController = TextEditingController();

  bool isPassVis = false;
  bool isConfirmPassVis = false;
  MyController myController = Get.put(MyController());

  void submit() async {
    var ok = formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    await myController.getUsers();

    if (ok!) {
      formKey.currentState?.save();
     // print("the passssss is $confirmPassword");
      await myController.addUser(
          user: User(
              id: 0,
              name: fullName,
              phone: phoneCode + phoneNumber,
              email: email,
              password: password));
      await myController.getUsers();

      int indexOfUser =
          myController.users.indexWhere((element) => element.email == email);
    //  print("*****************************");
      if (indexOfUser >= 0) {
        int userId = myController.users[indexOfUser].id;
        var prefs = await SharedPreferences.getInstance();
        await prefs.setInt("isExist", userId);
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
    bool isToken = false;
    myController.getUsers();
    print(email);
    myController.users.forEach((element) {
      if (element.email.toString() == email.toString()) isToken = true;
    });
    print(isToken);
    return isToken ? true : false;
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 35,
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
                  "Register",
                  style: MyTextStyle.AlexandriaFLF_Bold,
                ),
                SizedBox(
                  height: 45,
                ),
                Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildNameTextFormField(),
                        SizedBox(
                          height: 25,
                        ),
                        buildPhoneNumberFormField(),
                        SizedBox(
                          height: 25,
                        ),
                        buildEmailFormField(),
                        SizedBox(
                          height: 25,
                        ),
                        buildPassTextFormField(),
                        SizedBox(
                          height: 25,
                        ),
                        buildConfirmPassTextFormField(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                buildElevatedButton(),
                SizedBox(
                  height: 80,
                ),
                buildRow()
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
          "Already have an account?",
          style: TextStyle(
              fontFamily: "AlexandriaFLF-Italic", color: Colors.deepPurple),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/logIn');
          },
          child: Text(
            " Login",
            style: TextStyle(
                fontFamily: 'AlexandriaFLF-Bold',
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple),
          ),
        ),
      ],
    );
  }

  ElevatedButton buildElevatedButton() {
    return ElevatedButton(
        onPressed: () {
          submit();
        },
        child: Text(
          "Register",
          style: TextStyle(color: Colors.white),
        ),
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(Size(180, 40)),
          backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
        ));
  }

  Container buildNameTextFormField() {
    return Container(
      margin: EdgeInsets.only(left: 60, right: 60),
      child: TextFormField(
        textAlign: TextAlign.center,
        key: ValueKey("fullName"),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black26,
              ),
            ),
            hintText: "Full Name",
            hintStyle: TextStyle(
              fontFamily: "AlexandriaFLF-Bold",
            )),
        validator: (val) {
          if (val!.isEmpty) return "Please enter your name";
          if (val.isNum) return "Please enter at least one character";
          return null;
        },
        onSaved: (val) => fullName = val!.toString(),
      ),
    );
  }

  Container buildEmailFormField() {
    return Container(
      margin: EdgeInsets.only(left: 60, right: 60),
      child: TextFormField(
        textAlign: TextAlign.center,
        key: ValueKey("email"),
        validator: (val) {
          bool isToken = check(val.toString());
          if (val!.isEmpty || !val.contains('@gmail.com')) {
            return "Please enter a valid email address";
          }
          if (isToken) return "email is already token";
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
            return "Please enter at last 7 character";
          }
          if (val.isNum) return "Please enter at least one character";
          return null;
        },
        onSaved: (val) => password = val!.toString(),
        obscureText: !isPassVis ? true : false,
        controller: passwordController,
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

  Container buildConfirmPassTextFormField() {
    return Container(
      decoration: BoxDecoration(),
      margin: EdgeInsets.only(left: 60, right: 60),
      child: TextFormField(
        textAlign: TextAlign.center,
        key: ValueKey("Confirm Password"),
        validator: (val) {
          if (val!.isEmpty) {
            return "Please enter at last 7 character";
          } else if (val.toString() != passwordController.text.toString()) {
            print(val);
            print(passwordController.text);
            return "The password not match";
          }
          return null;
        },
        onSaved: (val) => confirmPassword = val!.toString(),
        obscureText: !isConfirmPassVis ? true : false,
        decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isConfirmPassVis = !isConfirmPassVis;
                });
              },
              icon: Icon(
                  !isConfirmPassVis ? Icons.visibility : Icons.visibility_off),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black26,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: "Confirm Password",
            hintStyle: TextStyle(fontFamily: "AlexandriaFLF-Bold")),
      ),
    );
  }

  Container buildPhoneNumberFormField() {
    return Container(
      margin: EdgeInsets.only(left: 60, right: 60),
      child: Builder(builder: (context) {
        return TextFormField(
          keyboardType: TextInputType.number,
          enabled: true,
          textAlign: TextAlign.center,
          key: ValueKey("phoneNumber"),
          validator: (val) {
            if (val!.isEmpty || val.length != 9) {
              return "Please enter  9 numbers";
            }
            return null;
          },
          onSaved: (val) => phoneNumber = val!,
          decoration: InputDecoration(
              prefixIcon: IconButton(
                icon: Icon(
                  Icons.flag,
                  color: Colors.deepPurple,
                ),
                onPressed: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: true,
                    // optional. Shows phone code before the country name.
                    onSelect: (Country country) {
                      setState(() {
                        nameCode = country.name;
                        phoneCode = country.phoneCode;
                      });
                      ;
                      Scaffold.of(context).showSnackBar(SnackBar(
                        duration: Duration(microseconds: 1000000),
                        content: Text(
                          "state is ${nameCode} +${phoneCode}",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.deepPurple,
                      ));
                    },
                  );
                },
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.black26,
                ),
              ),
              hintText: "Phone Number",
              hintStyle: TextStyle(fontFamily: "AlexandriaFLF-Bold")),
        );
      }),
    );
  }
}
