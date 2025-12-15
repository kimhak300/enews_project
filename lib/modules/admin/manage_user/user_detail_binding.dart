import 'package:get/get.dart';
import 'package:newshub/modules/admin/manage_user/user_detail_controller.dart';

class UserDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserDetailController>(() => UserDetailController());
  }
}
