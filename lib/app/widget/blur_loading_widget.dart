import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlurLoadingWidget {
  static void show() {
    Get.dialog(
      Stack(
        children: [

          /// Blur background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),

          /// Center loading
          const Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  static void hide() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}