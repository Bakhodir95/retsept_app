// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final _dio = Dio();

  Future<String?> getToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final String? userData = sharedPreferences.getString('userData');

    if (userData == null) {
      return null;
    }

    final Map<String, dynamic> userMap = jsonDecode(userData);
    final User user = User.fromJson(userMap);

    return user.token;
  }

  Future<String?> getUserId() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final String? userData = sharedPreferences.getString('userData');

    if (userData == null) {
      return null;
    }

    final Map<String, dynamic> userMap = jsonDecode(userData);
    final User user = User.fromJson(userMap);

    return user.id;
  }

  DioClient._private() {
    _dio.options
      ..connectTimeout = const Duration(seconds: 10)
      ..receiveTimeout = const Duration(seconds: 10)
      ..baseUrl = "https://retsept-app-default-rtdb.firebaseio.com/";
  }

  static final _singletonConstructor = DioClient._private();

  factory DioClient() {
    return _singletonConstructor;
  }

  Future<Response> get({
    required String url,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        "$url?auth=$token",
        queryParameters: queryParams,
      );
      return response;
    } on DioException catch (e) {
      print('DioException: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('General Exception: $e');
      rethrow;
    }
  }

  Future<Response> add({
    required String url,
    Map<String, dynamic>? data,
  }) async {
    try {
      final token = await getToken();

      final response = await _dio.post(
        "$url?auth=$token",
        data: data,
      );

      return response;
    } on DioException catch (e) {
      print('DioException: ${e.response!.data}');
      rethrow;
    } catch (e) {
      print('General Exception: $e');
      rethrow;
    }
  }

  Future<Response> update({
    required String url,
    Map<String, dynamic>? data,
  }) async {
    try {
      final token = await getToken();

      final response = await _dio.patch(
        "$url?auth=$token",
        data: data,
      );
      return response;
    } on DioException catch (e) {
      print("Dio Clients Error: ${e.response!.data}");
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete({
    required String url,
    Map<String, dynamic>? data,
  }) async {
    try {
      final token = await getToken();

      final response = await _dio.delete(
        "$url?auth=$token",
        data: data,
      );
      return response;
    } on DioException catch (e) {
      print("Dio Clients Delete Error: ${e.response!.data}");
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
