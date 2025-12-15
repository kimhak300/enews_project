import 'package:get/get.dart';

class HelpSupportController extends GetxController {
  final expandedFaqIndex = Rx<int?>(-1);
  
  final faqs = <Map<String, String>>[
    {
      'question': 'how_to_create_account',
      'answer': 'how_to_create_account_answer',
    },
    {
      'question': 'how_to_reset_password',
      'answer': 'how_to_reset_password_answer',
    },
    {
      'question': 'how_to_post_article',
      'answer': 'how_to_post_article_answer',
    },
    {
      'question': 'how_to_save_article',
      'answer': 'how_to_save_article_answer',
    },
    {
      'question': 'how_to_report_content',
      'answer': 'how_to_report_content_answer',
    },
    {
      'question': 'how_to_delete_account',
      'answer': 'how_to_delete_account_answer',
    },
  ].obs;

  void toggleFaq(int index) {
    if (expandedFaqIndex.value == index) {
      expandedFaqIndex.value = -1;
    } else {
      expandedFaqIndex.value = index;
    }
  }

  void sendFeedback(String message) {
    // TODO: Implement API call to send feedback
    print('Sending feedback: $message');
    Get.back();
    Get.snackbar(
      'success'.tr,
      'feedback_sent_successfully'.tr,
      snackPosition: SnackPosition.TOP,
    );
  }
}
