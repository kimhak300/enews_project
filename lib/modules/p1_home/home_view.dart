import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/app/widget/app_layout_widget.dart';
import 'package:newshub/data/models/category_model.dart';
import 'package:newshub/modules/p1_home/widget/category_card_widget.dart';
import 'package:newshub/modules/p1_home/widget/news_widget.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AppLayoutWidget(
      leftWidget: ClipOval(
        child: Image.asset("assets/images/logo1.png", height: 50, width: 50,),
      ),
      title: "E-New",
      rightWidget: GestureDetector(
        onTap: (){},
        child: Icon(Icons.language),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSpacing.paddingM),
            Flexible(
              flex: 1,
              child: _categories(),
            ),
            SizedBox(height: AppSpacing.paddingM),
            Flexible(
                flex: 9,
                child: SingleChildScrollView(
                  child: _newsList(),
                )
            ),
          ],
        ),
      ),
    );
  }

  Widget _categories(){
    return Obx(() => SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final CategoryModel category = controller.categories[index];
          return CategoryCard(category: category);
        },
      ),
    ));
  }

  Widget _newsList(){
    return Column(
      children: [
        NewsWidget(
          username: 'John Doe',
          time: '2 hours ago',
          caption: 'Check out this amazing view!',
          imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
        ),
        SizedBox(height: AppSpacing.paddingS),
        NewsWidget(
          username: 'John Doe',
          time: '2 hours ago',
          caption: 'Check out this amazing view!',
          imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
        ),
      ],
    );
  }
}