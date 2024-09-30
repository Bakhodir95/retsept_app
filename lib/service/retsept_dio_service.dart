// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:retsept_app/core/network/dio_client.dart';
import 'package:retsept_app/data/models/food_models.dart';

class RetseptService {
  final _dio = DioClient();

  Future<List<Food>> getRetsept() async {
    try {
      final response = await _dio.get(url: "/retsept.json");
      print("+++++++++++++++++++++++");
      print(response.headers.value("location"));

      if (response.statusCode == 302) {
        final redirectUrl = response.headers.value("location");
        print(redirectUrl);
        if (redirectUrl != null) {
          final redirectedResponse = await _dio.get(url: "/retsept.json");

          if (redirectedResponse.statusCode == 200) {
            print(redirectedResponse.data);
            return parseRetsept(redirectedResponse.data);
          } else {
            throw Exception("Redirection URL not found.");
          }
        } else {
          throw Exception("Redirect URL not found");
        }
      } else if (response.statusCode == 200) {
        return parseRetsept(response.data);
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("Transaction DioException: ${e.response?.data}");
      rethrow;
    } catch (e) {
      print("Error during get: $e");
      rethrow;
    }
  }

  List<Food> parseRetsept(Map<String, dynamic> data) {
    List<Food> retsepts = [];

    data.forEach((key, value) {
      try {
        value['id'] = key;
        retsepts.add(Food.fromMap(value));
      } catch (e) {
        print("Error parsing retsept: $value - Error: $e");
      }
    });

    return retsepts;
  }

  Future<Food> addRetsept(Food retsept) async {
    try {
      final response = await _dio.add(
        url: "/retsept.json",
        data: retsept.toMap(),
      );

      if (response.statusCode == 302) {
        final redirectUrl = response.headers.value('location');
        if (redirectUrl != null) {
          final redirectedResponse = await _dio.add(
            url: redirectUrl,
          );
          if (redirectedResponse.statusCode == 200) {
            return Food.fromMap(redirectedResponse.data);
          } else {
            throw Exception('Redirected request failed.');
          }
        } else {
          throw Exception('Redirect URL not found.');
        }
      } else if (response.statusCode == 200) {
        return Food.fromMap(response.data);
      } else {
        throw Exception('Failed to add retsept: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print("Dio service error: $e");
      rethrow;
    } catch (e) {
      print("Error during add: $e");
      rethrow;
    }
  }

  Future<Food> editRetsept(String id, Food updatedRetsept) async {
    try {
      final response = await _dio.update(
        url: "/retsept/$id.json", // Firebase uchun ma'lumotni tahrirlash URL
        data: updatedRetsept.toMap(),
      );

      if (response.statusCode == 200) {
        return Food.fromMap(response.data);
      } else {
        throw Exception('Failed to edit retsept: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print("Dio service error: $e");
      rethrow;
    } catch (e) {
      print("Error during edit: $e");
      rethrow;
    }
  }

  Future deleteRetsept(String id) async {
    try {
      final response = await _dio.delete(url: "/retsept/$id.json");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to delete retsept: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print("Dio service error delete: $e");
      rethrow;
    } catch (e) {
      print("Error during delete: $e");
      rethrow;
    }
  }

  Future<List<Food>> getUserRecepts() async {
    try {
      String? id = await _dio.getUserId();

      final response = await _dio.get(
        url: "/retsept.json",
        queryParams: {
          'orderBy': '"userId"',
          'equalTo': '"$id"',
        },
      );

      if (response.statusCode == 302) {
        final redirectUrl = response.headers.value("location");
        if (redirectUrl != null) {
          final redirectedResponse = await _dio.get(url: redirectUrl);

          if (redirectedResponse.statusCode == 200) {
            return parseRetsept(redirectedResponse.data);
          } else {
            throw Exception("Redirection URL not found.");
          }
        } else {
          throw Exception("Redirect URL not found");
        }
      } else if (response.statusCode == 200) {
        final Map<String, dynamic>? foodData =
            response.data as Map<String, dynamic>?;

        if (foodData != null && foodData.isNotEmpty) {
          return parseRetsept(foodData);
        } else {
          return [];
        }
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("Dio service error: ${e.response?.data}");
      rethrow;
    } catch (e) {
      print("Error during getUserRecepts: $e");
      rethrow;
    }
  }
}
