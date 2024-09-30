import 'package:retsept_app/data/models/food_models.dart';
import 'package:retsept_app/service/retsept_dio_service.dart';

class RetseptRepository {
  final RetseptService _retseptService;

  RetseptRepository({
    required RetseptService retseptService,
  }) : _retseptService = retseptService;

  Future<List<Food>> getRetsepts() async {
    return await _retseptService.getRetsept();
  }
  Future<List<Food>> getUserRetsepts() async {
    return await _retseptService.getUserRecepts();
  }

  Future<Food> addRetsept(Food retsept) async {
    return await _retseptService.addRetsept(retsept);
  }

  Future<Food> editRetsept(String id, Food updatedRetsept) async {
    return await _retseptService.editRetsept(id, updatedRetsept);
  }

  Future deleteRetsept(String id) async {
    return await _retseptService.deleteRetsept(id);
  }
}
