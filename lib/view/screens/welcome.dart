import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:task/controller/muController.dart';
import 'package:task/styles/textStyle.dart';
import 'package:task/view/widgets/button.dart';
import '../../controller/muController.dart';
import '../../model/userInfo.dart';

class Welcome extends StatelessWidget {
  Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
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
                  "Welcome to the app",
                  style: MyTextStyle.AlexandriaFLF_Bold,
                ),
                SizedBox(
                  height: 230,
                ),
                MyButton(text: "Login", isLogIn: true),
                SizedBox(
                  height: 5,
                ),
                MyButton(text: "Register", isLogIn: false),
                SizedBox(
                  height: 300,
                ),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Designed & Developed by",
                        style: TextStyle(
                            fontFamily: "AlexandriaFLF-Italic",
                            color: Colors.deepPurple),
                      ),
                      TextSpan(
                        text: " Ali Fouad",
                        style: TextStyle(
                            fontFamily: 'AlexandriaFLF-Bold',
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
