import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/muController.dart';
import '../../styles/textStyle.dart';

class ChangePasswordPage extends StatefulWidget {
   ChangePasswordPage({Key? key , required this.userId}) : super(key: key);
  int userId;

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  String password = "";
  String confirmPassword = "";
  TextEditingController passwordController=TextEditingController();
  var formKey = GlobalKey<FormState>();

  bool isChanged=false;

  bool isPassVis = false;
  bool isConfirmPassVis = false;
  MyController myController = Get.put(MyController());

  void submit() async{
    var ok = formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    await myController.getUsers();

    if (ok!) {
      formKey.currentState?.save();
    await  myController.updatePassword(widget.userId, password.toString());
      isChanged=true;
     await myController.getUsers();
    Navigator.pop(context , isChanged);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.deepPurple.shade900,
      leading: IconButton(
        onPressed: (){
          Navigator.pop(context , isChanged);
        },
        icon: Icon(Icons.arrow_back_ios),
      ),
      title: Center(
        child: Text(
          "Change Password",
          style: MyTextStyle.myFont,
        ),
      ),
    ),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 30),
            child: Form(
            key: formKey,
            child: Column(
              children: [
                buildPassTextFormField(),
                SizedBox(height: 30,),
                buildConfirmPassTextFormField(),
                SizedBox(height: 30,),
                buildElevatedButton()

              ],
            ),
          ),
          ),
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
        onSaved: (val) => password = val.toString(),
        obscureText: !isPassVis ? true : false,
        controller:passwordController ,
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
            hintText: "New Password",
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
            //print(val);
         //   print(passwordController.text);
            return "The password not match";
          }

          return null;
        },
        onSaved: (val) => confirmPassword = val.toString(),
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
  ElevatedButton buildElevatedButton() {
    return ElevatedButton(
        onPressed: () {
          submit();
        },
        child: Text(
            "Save",
            style:MyTextStyle.myFont
        ),
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(Size(180, 40)),
          backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
        ));
  }
}
