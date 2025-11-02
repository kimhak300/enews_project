import '../controllers/ratio_controller.dart';

class AppFontSize {

  static RatioController get _ratio => RatioController.to;

  /// Display
  static double get displayLarge => _ratio.scaledFont(57);
  static double get displayMedium => _ratio.scaledFont(45);
  static double get displaySmall => _ratio.scaledFont(36);

  /// Headline
  static double get headlineLarge => _ratio.scaledFont(32);
  static double get headlineMedium => _ratio.scaledFont(28);
  static double get headlineSmall => _ratio.scaledFont(24);

  /// Title
  static double get titleLarge => _ratio.scaledFont(22);
  static double get titleMedium => _ratio.scaledFont(16);
  static double get titleSmall => _ratio.scaledFont(14);

  /// Body
  static double get bodyLarge => _ratio.scaledFont(16);
  static double get bodyMedium => _ratio.scaledFont(14);
  static double get bodySmall => _ratio.scaledFont(12);

  /// Label
  static double get labelLarge => _ratio.scaledFont(14);
  static double get labelMedium => _ratio.scaledFont(12);
  static double get labelSmall => _ratio.scaledFont(11);
}