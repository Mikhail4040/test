import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task/styles/textStyle.dart';

import '../../controller/muController.dart';
import '../../model/userInfo.dart';

class UpdatePage extends StatefulWidget {
   UpdatePage({Key? key , required this.userId}) : super(key: key);
  int userId;


  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  String phoneNumber = "";
  String phoneCode="971";
  String nameCode="";
  String email = "";
  String fullName = "";

  String realNumber="";
  String countryCode="";

  String? userName;
  int? userPhoneNumber;
  String? userEmail;

  bool isUpdate=false;
  var formKey = GlobalKey<FormState>();

  MyController myController = Get.put(MyController());
  bool check(String email){
    bool isToken=false;
    myController.getUsers();
    print("is token email $email");
    myController.users.forEach((element) {
      if(element.email.toString() == email.toString())
        isToken=true;
    });
    print(isToken);
    return isToken?true:false;
  }

  void init()async{
    print(widget.userId);
    await myController.getUsers();
    int indexOfUser = myController.users.indexWhere((element) => element.id == widget.userId);

    var userInfo=myController.users[indexOfUser];
    print(userInfo.name);
    print(userInfo.email);
    setState(() {

      userName = userInfo.name;
      userPhoneNumber = userInfo.phone;
      userEmail = userInfo.email;

      fullName=userName.toString();
      phoneNumber=userPhoneNumber.toString();
      email=userEmail.toString();

      print(userName);

    });
    String Number = userPhoneNumber.toString();
    Number=Number.split('').reversed.join('');
    realNumber=Number.substring(0 , 9);
    countryCode = Number.substring(9);
    realNumber=realNumber.split('').reversed.join('');
    countryCode=countryCode.split('').reversed.join('');
   // print("The user Id is ${realNumber}");
   // print("The user Id is ${countryCode}");
  }


  void submit() async{
    var ok = formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
  //  await myController.getUsers();

    if (ok!) {
      formKey.currentState?.save();
      print("email is $email");


      if(fullName.toString() != userName.toString() || countryCode+realNumber.toString() != userPhoneNumber.toString() || email.toString() != userEmail.toString()){
        setState(() {
          isUpdate=true;
        });
      }

     await myController.updateName(widget.userId , fullName.toString());
     await myController.updatePhone(widget.userId,countryCode+realNumber);

      print("email is $email");
      await myController.updateEmail(widget.userId, email.toString());
     await myController.getUsers();

      int indexOfUser = myController.users.indexWhere((element) => element.id == widget.userId);
      // print(myController.users[indexOfUser].name);
      // print(myController.users[indexOfUser].phone);
       print(myController.users[indexOfUser].email);
      print("email is $email");
     if(isUpdate)
       Navigator.pop(context,isUpdate);

    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade900,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context,isUpdate);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Center(
          child: Text(
            "Update Information",
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
                  buildNameTextFormField(userName.toString()),
                  SizedBox(height: 30,),
                  buildPhoneNumberFormField(realNumber.toString()),
                  SizedBox(height: 30,),
                  buildEmailFormField(userEmail.toString()),
                  SizedBox(height: 30,),
                  buildElevatedButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Container buildPhoneNumberFormField(String number) {
    return Container(
      margin: EdgeInsets.only(left: 60, right: 60),
      child: Builder(
          builder: (context) {
            return TextFormField(
              keyboardType: TextInputType.number,
              enabled: true,
              textAlign: TextAlign.center,
              key: ValueKey("phoneNumber"),
              validator: (val) {
                if (val!.isNotEmpty && val.length != 9) {
                  return "Please enter  9 numbers";
                }
                return null;
              },
              onSaved: (val){
                if(val!.isNotEmpty)
                  realNumber = val;
              },
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(Icons.flag,color: Colors.deepPurple,),
                    onPressed: () {
                      showCountryPicker(
                        context: context,
                        showPhoneCode: true,
                        onSelect: (Country country) {
                          setState(() {
                            nameCode=country.name;
                            phoneCode=country.phoneCode;
                            countryCode = country.phoneCode;
                            print("Country codeeeee is ${countryCode}");
                          //  phoneNumber=phoneCode + ;
                          });;
                          Scaffold.of(context).showSnackBar(SnackBar(
                            duration: Duration(microseconds: 1000000),
                            content:Text("state is ${nameCode } +${phoneCode}",style: TextStyle(color: Colors.white),),
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
                  hintText: number,
                  hintStyle: TextStyle(fontFamily: "AlexandriaFLF-Bold")),
            );
          }
      ),
    );
  }
  Container buildNameTextFormField(String title) {
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
            hintText: title,
            hintStyle: TextStyle(
              fontFamily: "AlexandriaFLF-Bold",
            )),
        validator: (val) {
          if(val!.isNum) return "Please enter at least one character";
          return null;
        },
        onSaved: (val){
          if(val!.isNotEmpty)
            fullName = val.toString();
        },
      ),
    );
  }
  Container buildEmailFormField(String email1) {

    return Container(
      margin: EdgeInsets.only(left: 60, right: 60),
      child: TextFormField(
        textAlign: TextAlign.center,
        key: ValueKey("email"),
        validator: (val) {
          bool isToken = check(val.toString());
          if (val!.isNotEmpty && !val.contains('@gmail.com')) {
            return "Please enter a valid email address";
          }
          if(isToken)
            return "email is already token";
          return null;
        },
        onSaved: (val){
          if(val!.isNotEmpty) {
            email = val.toString();
          //  print("enmaillllllllllllllll is $email");
          }
        },
        decoration: InputDecoration(
            hintText: email1,
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
