import 'package:get/get.dart';
import 'package:newshub/data/models/category_model.dart';

class HomeController extends GetxController {

  var categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchCategories() {
    var serverResponse = [
      CategoryModel(id: 1, name: 'Home', imageUrl: 'https://i.imgur.com/4YxF7.jpg'),
      CategoryModel(id: 2, name: 'Following', imageUrl: 'https://i.imgur.com/1G2T.jpg'),
      CategoryModel(id: 3, name: 'Popular', imageUrl: 'https://i.imgur.com/7pL0.jpg'),
      CategoryModel(id: 4, name: 'News', imageUrl: 'https://i.imgur.com/Nj3Q.jpg'),
      CategoryModel(id: 5, name: 'Home', imageUrl: 'https://i.imgur.com/4YxF7.jpg'),
      CategoryModel(id: 6, name: 'Following', imageUrl: 'https://i.imgur.com/1G2T.jpg'),
      CategoryModel(id: 7, name: 'Popular', imageUrl: 'https://i.imgur.com/7pL0.jpg'),
      CategoryModel(id: 8, name: 'News', imageUrl: 'https://i.imgur.com/Nj3Q.jpg'),
    ];
    categories.assignAll(serverResponse);
  }

}