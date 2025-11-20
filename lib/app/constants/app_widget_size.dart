import '../controllers/ratio_controller.dart';

class AppWidgetSize {
  static RatioController get _ratio => RatioController.to;

  /// Icon Sizes
  static double get iconXS => _ratio.scaledSize(12);
  static double get iconSmall => _ratio.scaledSize(16);
  static double get iconSM => _ratio.scaledSize(20);
  static double get iconMedium => _ratio.scaledSize(24);
  static double get iconLarge => _ratio.scaledSize(32);
  static double get iconXL => _ratio.scaledSize(40);
  static double get iconXXL => _ratio.scaledSize(48);

  /// Image Sizes
  static double get imageXS => _ratio.scaledSize(24);
  static double get imageSmall => _ratio.scaledSize(48);
  static double get imageSM => _ratio.scaledSize(72);
  static double get imageMedium => _ratio.scaledSize(96);
  static double get imageLarge => _ratio.scaledSize(120);
  static double get imageXL => _ratio.scaledSize(150);
  static double get imageXXL => _ratio.scaledSize(200);

  /// Logo Sizes (can be separate if needed)
  static double get logoSmall => _ratio.scaledSize(64);
  static double get logoMedium => _ratio.scaledSize(96);
  static double get logoLarge => _ratio.scaledSize(128);
  static double get logoXL => _ratio.scaledSize(160);
}