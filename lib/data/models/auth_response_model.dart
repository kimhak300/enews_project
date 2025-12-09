import 'package:newshub/data/models/user_model.dart';

class AuthResponseModel {
	final bool success;
	final String? message;
	final String token;
	final UserModel user;

	AuthResponseModel({
		required this.success,
		required this.token,
		required this.user,
		this.message,
	});

	factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
		return AuthResponseModel(
			success: json['success'] ?? false,
			message: json['message'] as String?,
			token: json['token'] ?? '',
			user: UserModel.fromJson(json['user'] ?? {}),
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'success': success,
			'message': message,
			'token': token,
			'user': user.toJson(),
		};
	}
}