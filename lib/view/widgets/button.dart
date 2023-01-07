import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
   MyButton({Key? key , required this.text , required this.isLogIn}) : super(key: key);

  bool isLogIn;
  String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: (){
          isLogIn?
          Navigator.pushReplacementNamed(context, '/logIn'):
          Navigator.pushReplacementNamed(context, '/register');

        },
        style:ButtonStyle(
          fixedSize: MaterialStateProperty.all(Size(180,40)),
          backgroundColor: MaterialStateProperty.all(isLogIn?Colors.deepPurple : Colors.white)
        ) ,
        child: Text(text , style: TextStyle(
          color: isLogIn?Colors.white : Colors.deepPurple,
          fontFamily: "AlexandriaFLF-Bold"
        ),),
    );
  }
}
