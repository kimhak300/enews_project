import 'package:get/get.dart';
import 'edit_video_controller.dart';

class EditVideoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditVideoController>(() => EditVideoController());
  }
}
