

class User{
   int id;
  String name;
  var phone;
  String email;
  String password;
  User({required this.id , required this.name ,required this.phone ,required this.email ,required this.password});

  Map<String,dynamic> toJson() {
    return {

      "name": name,
      "phone": phone,
      "email": email,
      "password": password,

    };
  }
}