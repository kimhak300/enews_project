import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// RatioController handles responsive scaling for fonts, sizes, padding, margin, and radius.
/// Works for Mobile, Tablet, Web, Desktop.
class RatioController extends GetxController {

  /// Singleton shortcut
  static RatioController get to => Get.find<RatioController>();

  /// Base width of your design (e.g., iPhone X)
  final double baseWidth = 375.0;

  /// Base height of your design (optional)
  final double baseHeight = 812.0;

  /// Initialize ScreenUtil (call this in main before runApp)
  void init(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: Size(baseWidth, baseHeight),
      minTextAdapt: true,
      splitScreenMode: true,
    );
  }

  /// Detect if device is tablet
  bool get isTablet => ScreenUtil().screenWidth >= 600;

  /// Detect if device is mobile
  bool get isMobile => !isTablet && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android);

  /// Detect if device is desktop
  bool get isDesktop => defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS;

  /// Detect if device is web
  bool get isWeb => kIsWeb;

  /// General scaling ratio for sizes, icons, padding, radius
  double get generalRatio {
    double ratio = ScreenUtil().screenWidth / baseWidth;

    if (isTablet) ratio *= 1.4;
    if (isMobile && defaultTargetPlatform == TargetPlatform.android) ratio *= 0.9;
    if (isMobile && defaultTargetPlatform == TargetPlatform.iOS) ratio *= 1.0;
    if (isDesktop) ratio *= 1.6;
    if (isWeb) ratio *= 1.4;

    return ratio;
  }

  /// Font scaling ratio
  double get fontRatio {
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;

    double ratio = (width + height) / 2 / 750;

    if (isTablet) ratio *= 1.4;
    if (isMobile && defaultTargetPlatform == TargetPlatform.android) ratio *= 0.9;
    if (isMobile && defaultTargetPlatform == TargetPlatform.iOS) ratio *= 1.02;
    if (isDesktop) ratio *= 1.6;
    if (isWeb) ratio *= 1.4;

    return ratio;
  }

  /// Scale font size
  double scaledFont(double baseSize) => (baseSize * fontRatio).spMin;

  /// Scale general size (padding, icon, width, height)
  double scaledSize(double baseSize) => (baseSize * generalRatio).w;

  /// Scale radius
  double scaledRadius(double baseRadius) => (baseRadius * generalRatio).r;

  /// Scale padding
  double scaledPadding(double basePadding) => (basePadding * generalRatio).w;

  /// Scale width
  double scaledWidth(double baseWidth) => (baseWidth * generalRatio).w;

  /// Scale height
  double scaledHeight(double baseHeight) => (baseHeight * generalRatio).h;
}