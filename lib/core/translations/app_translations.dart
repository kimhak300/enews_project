import 'package:get/get.dart';
import '../localization/en_us.dart';
import '../localization/km_kh.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUs,
    'km_KH': kmKh,
  };
}