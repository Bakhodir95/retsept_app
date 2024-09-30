import 'package:retsept_app/data/models/category_models.dart';
import 'package:retsept_app/service/category_services.dart';

class CategoryRepository {
  final DioCategoriesServices _dioCategoriesServices;

  CategoryRepository({required DioCategoriesServices dioCategoriesServices})
      : _dioCategoriesServices = dioCategoriesServices;

  Future<List<CategoriesModel>> getCategories() async {
    return _dioCategoriesServices.getCategories();
  }

  Future addCategories(String name) async {
    return _dioCategoriesServices.addCategories(name);
  }

}
