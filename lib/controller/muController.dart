import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../model/dp.dart';
import '../model/userInfo.dart';

class MyController extends GetxController {
  List<User> users = <User>[].obs;

  Future<int> addUser({required User user}) async {
    return DBHelper.insert(user);
  }

  getUsers() async {
    List<Map<String, dynamic>> users1 = await DBHelper.query();
    print(users1);
    users.assignAll(users1.map((json) {
      return User(
          id: json['id'],
          name: json['name'],
          phone: json['phone'],
          email: json['email'],
          password: json['password'].toString());
    }).toList());
  }

  Future DeleteUser(int id) async {
    await DBHelper.delete(id);

    // print("From Delete Function Called getWords");
  }

  DeleteAllUsers() async {
    await DBHelper.deleteAll();
    // print("From DeleteAllTasks Function Called getWords");
  }

  Future updateName(int id, String name) async {
    await DBHelper.updateName(id, name);
    // print("From updateWords Function Called getWords");
  }

  Future updatePhone(int id, String phone) async {
    await DBHelper.updatePhone(id, phone);
    // print("From updateTranslated Function Called getWords");
  }

  Future updateEmail(int id, String email) async {
    await DBHelper.updateEmail(id, email);
    // print("From updateTranslated Function Called getWords");
  }

  Future updatePassword(int id, String password) async {
    await DBHelper.updatePassword(id, password);
    print("From Password Updater siuuuu!");
  }
}
