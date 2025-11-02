import 'package:get/get.dart';
import 'en_us.dart';
import 'km_kh.dart';

class AppLocalization extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUs,
        'km_KH': kmKh,
      };
}
