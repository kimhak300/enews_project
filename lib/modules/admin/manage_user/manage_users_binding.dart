import 'package:get/get.dart';
import 'manage_users_controller.dart';
import 'package:newshub/api/controller/user_controller.dart';

class ManageUsersBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<ManageUsersController>(() => ManageUsersController());
    Get.lazyPut<UserController>(() => UserController());
  }

}