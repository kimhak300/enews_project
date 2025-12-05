import 'package:get/get.dart';
import 'package:newshub/core/localization/km_kh.dart';
import 'package:newshub/core/localization/en_us.dart';

class AppTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUs,
    'km_KH': kmKh,
  };
}