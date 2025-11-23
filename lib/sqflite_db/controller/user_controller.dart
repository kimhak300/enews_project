import 'package:get/get.dart';
import 'package:newshub/sqflite_db/model/user_model.dart';
import 'package:newshub/sqflite_db/service/user_service.dart';

class UserController extends GetxController {

  var users = <UserModel>[].obs;
  final UserService _userService = UserService();

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  void fetchUsers() async {
    users.value = await _userService.getAllUsers();
  }

  void addUser(UserModel user) async {
    await _userService.insertUser(user);
    fetchUsers();
  }

  void updateUser(UserModel user) async {
    await _userService.updateUser(user);
    fetchUsers();
  }

  void deleteUser(int id) async {
    await _userService.deleteUser(id);
    fetchUsers();
  }
}