// import 'package:flutter/material.dart';

// class Category {
//   final String id;
//   final String name;
//   final IconData icon;
//   final List<Color> gradientColors;
//   final int articleCount;

//   Category({
//     required this.id,
//     required this.name,
//     required this.icon,
//     required this.gradientColors,
//     this.articleCount = 0,
//   });

// ignore_for_file: unnecessary_new

//   static List<Category> getCategories() {
//     return [
//       Category(
//         id: 'technology',
//         name: 'Technology',
//         icon: Icons.computer,
//         gradientColors: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
//         articleCount: 245,
//       ),
//       Category(
//         id: 'business',
//         name: 'Business',
//         icon: Icons.business_center,
//         gradientColors: [const Color(0xFF11998E), const Color(0xFF38EF7D)],
//         articleCount: 189,
//       ),
//       Category(
//         id: 'sports',
//         name: 'Sports',
//         icon: Icons.sports_soccer,
//         gradientColors: [const Color(0xFFFF6B6B), const Color(0xFFFFE66D)],
//         articleCount: 321,
//       ),
//       Category(
//         id: 'health',
//         name: 'Health',
//         icon: Icons.favorite,
//         gradientColors: [const Color(0xFFFF9A9E), const Color(0xFFFECAB5)],
//         articleCount: 156,
//       ),
//       Category(
//         id: 'science',
//         name: 'Science',
//         icon: Icons.science,
//         gradientColors: [const Color(0xFF667EEA), const Color(0xFF667EEA)],
//         articleCount: 198,
//       ),
//       Category(
//         id: 'entertainment',
//         name: 'Entertainment',
//         icon: Icons.movie,
//         gradientColors: [const Color(0xFFFFA500), const Color(0xFFFFD700)],
//         articleCount: 287,
//       ),
//     ];
//   }
// }
class Category {
  String? id;
  String? name;
  String? icon;
  String? subtitle;

  Category({this.id, this.name, this.icon, this.subtitle});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    subtitle = json['subtitle'];
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['subtitle'] = this.subtitle;
    return data;
  }
}
