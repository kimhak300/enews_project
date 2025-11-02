import 'package:http/http.dart' as http;
import 'package:newshub/app/config/app_config.dart';
import 'dart:convert';
import '../../app/utils/constants.dart';
import 'network_exceptions.dart';

class ApiClient {
  final String baseUrl;
  final Map<String, String> headers;

  ApiClient({
    this.baseUrl = AppConfig.apiBaseUrl,
    Map<String, String>? headers,
  }) : headers = headers ?? {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        };

  // GET request
  Future<dynamic> get(String endpoint, {Map<String, String>? queryParams}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: headers).timeout(
        Constants.connectTimeout,
      );
      return _handleResponse(response);
    } catch (e) {
      throw NetworkExceptions.handleException(e);
    }
  }

  // POST request
  Future<dynamic> post(String endpoint, {dynamic body}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode(body),
      ).timeout(Constants.connectTimeout);
      return _handleResponse(response);
    } catch (e) {
      throw NetworkExceptions.handleException(e);
    }
  }

  // PUT request
  Future<dynamic> put(String endpoint, {dynamic body}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.put(
        uri,
        headers: headers,
        body: json.encode(body),
      ).timeout(Constants.connectTimeout);
      return _handleResponse(response);
    } catch (e) {
      throw NetworkExceptions.handleException(e);
    }
  }

  // DELETE request
  Future<dynamic> delete(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.delete(uri, headers: headers).timeout(
        Constants.connectTimeout,
      );
      return _handleResponse(response);
    } catch (e) {
      throw NetworkExceptions.handleException(e);
    }
  }

  // Handle response
  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return json.decode(response.body);
      case 400:
        throw NetworkExceptions.badRequest(response.body);
      case 401:
        throw NetworkExceptions.unauthorised();
      case 403:
        throw NetworkExceptions.forbidden();
      case 404:
        throw NetworkExceptions.notFound(response.body);
      case 500:
      default:
        throw NetworkExceptions.serverError();
    }
  }
}
