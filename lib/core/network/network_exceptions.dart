import 'dart:io';
import 'dart:async';

class NetworkExceptions {
  static String handleException(dynamic error) {
    if (error is SocketException) {
      return 'No internet connection';
    } else if (error is TimeoutException) {
      return 'Request timeout. Please try again';
    } else if (error is HttpException) {
      return 'HTTP error occurred';
    } else if (error is FormatException) {
      return 'Invalid response format';
    } else {
      return 'An unexpected error occurred';
    }
  }

  static String badRequest(String message) {
    return 'Bad Request: $message';
  }

  static String unauthorised() {
    return 'Unauthorised access. Please login again';
  }

  static String forbidden() {
    return 'Access forbidden';
  }

  static String notFound(String message) {
    return 'Resource not found: $message';
  }

  static String serverError() {
    return 'Server error. Please try again later';
  }

  static String noInternetConnection() {
    return 'No internet connection. Please check your network';
  }

  static String requestTimeout() {
    return 'Request timeout. Please try again';
  }
}
