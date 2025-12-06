import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/modules/auth/controllers/auth_controller.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final AuthController logoutController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              logoutController.logout();
            },
            child: Obx(() => logoutController.isLoading.value
                ? CircularProgressIndicator(color: Colors.white)
                : Text("Logout")),
          )
        ],
      ),
    );
  }
}
