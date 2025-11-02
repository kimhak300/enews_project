import '../controllers/ratio_controller.dart';

class AppSpacing {

  static RatioController get _ratio => RatioController.to;

  /// Padding
  static double get paddingXS => _ratio.scaledPadding(4);
  static double get paddingSmall => _ratio.scaledPadding(8);
  static double get paddingSM => _ratio.scaledPadding(12);
  static double get paddingMedium => _ratio.scaledPadding(16);
  static double get paddingLarge => _ratio.scaledPadding(20);
  static double get paddingXL => _ratio.scaledPadding(24);
  static double get paddingXXL => _ratio.scaledPadding(32);

  /// Margin
  static double get marginXS => _ratio.scaledPadding(4);
  static double get marginSmall => _ratio.scaledPadding(8);
  static double get marginSM => _ratio.scaledPadding(12);
  static double get marginMedium => _ratio.scaledPadding(16);
  static double get marginLarge => _ratio.scaledPadding(20);
  static double get marginXL => _ratio.scaledPadding(24);
  static double get marginXXL => _ratio.scaledPadding(32);
}