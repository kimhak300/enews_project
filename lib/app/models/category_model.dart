
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
