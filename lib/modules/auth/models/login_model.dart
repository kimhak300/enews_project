import 'package:get/get.dart';

class Login_Model {
  int? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  String? gender;
  String? image;
  String? accessToken;
  String? refreshToken;

  Login_Model(
      {this.id,
      this.username,
      this.email,
      this.firstName,
      this.lastName,
      this.gender,
      this.image,
      this.accessToken,
      this.refreshToken});

  Login_Model.fromJson(Map<String, dynamic> json) {
    id = json['id'.tr];
    username = json['username'.tr];
    email = json['email'.tr];
    firstName = json['firstName'.tr];
    lastName = json['lastName'.tr];
    gender = json['gender'.tr];
    image = json['image'.tr];
    accessToken = json['accessToken'.tr];
    refreshToken = json['refreshToken'.tr];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'.tr] = this.id;
    data['username'.tr] = this.username;
    data['email'.tr] = this.email;
    data['firstName'.tr] = this.firstName;
    data['lastName'.tr] = this.lastName;
    data['gender'.tr] = this.gender;
    data['image'.tr] = this.image;
    data['accessToken'.tr] = this.accessToken;
    data['refreshToken'.tr] = this.refreshToken;
    return data;
  }
}