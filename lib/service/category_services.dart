// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:retsept_app/core/network/dio_client.dart';
import 'package:retsept_app/data/models/category_models.dart';

class DioCategoriesServices {
  final DioClient _dio = DioClient();

  Future<List<CategoriesModel>> getCategories() async {
    try {
      final response = await _dio.get(url: "/category.json");

      if (response.statusCode == 302) {
        final redirectUrl = response.headers.value("location");
        if (redirectUrl != null) {
          final redirectedResponse = await _dio.get(url: "/category.json");

          if (redirectedResponse.statusCode == 200) {
            if (redirectedResponse.data != null &&
                redirectedResponse.data is Map) {
              return parseCategories(redirectedResponse.data);
            } else {
              throw Exception(
                  "Kutilgan ma'lumot turi noto'g'ri yoki ma'lumot bo'sh.");
            }
          } else {
            throw Exception("Redirection URL not found.");
          }
        } else {
          throw Exception("Url Manzili topilmadi");
        }
      } else if (response.statusCode == 200) {
        if (response.data != null && response.data is Map) {
          return parseCategories(response.data);
        } else {
          throw Exception(
              "Kutilgan ma'lumot turi noto'g'ri yoki ma'lumot bo'sh.");
        }
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("Category DioException Get: ${e.response!.data}");
      rethrow;
    } catch (e) {
      print("Get Qilishda Error: $e");
      rethrow;
    }
  }

  List<CategoriesModel> parseCategories(dynamic data) {
    List<CategoriesModel> categories = [];

    if (data != null && data is Map) {
      data.forEach((key, value) {
        value['id'] = key;
        categories.add(CategoriesModel.fromJson(value));
      });
    } else {
      throw Exception("Kutilgan ma'lumot turi noto'g'ri yoki ma'lumot bo'sh.");
    }

    return categories;
  }

  Future addCategories(String name) async {
    try {
      final response = await _dio.add(
        url: "/category.json",
        data: {
          "category-name": name,
        },
      );
      if (response.statusCode == 302) {
        final redirectUrl = response.headers.value('location');
        if (redirectUrl != null) {
          // Yo'naltirilgan URL ga so'rov yuborish
          final redirectedResponse = await _dio.get(
            url: redirectUrl,
          );
          // Yangi so'rovni qayta ishlash
          if (redirectedResponse.statusCode == 200) {
            return response.data;
          }
        } else {
          throw Exception('URL topilmadi');
        }
        return response.data;
      }
      return response.data;
    } catch (e) {
      print("Category qo'shishda Error: $e");
      rethrow;
    }
  }
}
