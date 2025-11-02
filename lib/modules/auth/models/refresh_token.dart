import 'package:get/get.dart';

class Refresh_Token {
  String? accessToken;
  String? refreshToken;

  Refresh_Token({this.accessToken, this.refreshToken});

  Refresh_Token.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'.tr];
    refreshToken = json['refreshToken'.tr];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'.tr] = this.accessToken;
    data['refreshToken'.tr] = this.refreshToken;
    return data;
  }
}