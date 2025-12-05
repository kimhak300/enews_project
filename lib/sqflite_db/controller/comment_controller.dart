import 'package:get/get.dart';
import 'package:newshub/sqflite_db/model/comment_model.dart';
import 'package:newshub/sqflite_db/service/comment_service.dart';

class CommentController extends GetxController {
  var comments = <CommentModel>[].obs;
  final CommentService _service = CommentService();

  @override
  void onInit() {
    super.onInit();
    fetchComments();
  }

  void fetchComments() async {
    comments.value = await _service.getAllComments();
  }

  void addComment(CommentModel comment) async {
    await _service.insertComment(comment);
    fetchComments();
  }

  void deleteComment(int id) async {
    await _service.deleteComment(id);
    fetchComments();
  }
}