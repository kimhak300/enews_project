import 'package:get/get.dart';
import 'package:newshub/sqflite_db/model/history_model.dart';
import 'package:newshub/sqflite_db/service/history_service.dart';

class HistoryController extends GetxController {
  var history = <HistoryModel>[].obs;
  final HistoryService _service = HistoryService();

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  void fetchHistory() async {
    history.value = await _service.getAllHistory();
  }

  void addHistory(HistoryModel h) async {
    await _service.insertHistory(h);
    fetchHistory();
  }

  int totalViews() =>
      history.where((h) => h.actionType == 'VIEW').length;

  int totalComments() =>
      history.where((h) => h.actionType == 'COMMENT').length;

  int totalShares() =>
      history.where((h) => h.actionType == 'SHARE').length;

  int totalProfileViews() =>
      history.where((h) => h.actionType == 'PROFILE_VIEW').length;
}