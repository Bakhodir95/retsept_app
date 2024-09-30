import 'package:bloc/bloc.dart';
import 'package:retsept_app/data/models/category_models.dart';
import 'package:retsept_app/data/repositories/category_repository.dart';
part "category_event.dart";
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;
  CategoryBloc({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        super(InitialCategoryState()) {
    on<GetCategoryEvent>(_getCategory);
    on<AddCategoryEvent>(_addCategory);
  }

  void _getCategory(GetCategoryEvent event, Emitter emit) async {
    emit(LoadingCategoryState());
    try {
      final categories = await _categoryRepository.getCategories();
      emit(LoadedCategoryState(categories: categories));
    } catch (e) {
      emit(ErrorCategoryState(message: e.toString()));
    }
  }

  void _addCategory(AddCategoryEvent event, Emitter emit) async {
  List<CategoriesModel> categories = [];
  if (state is LoadedCategoryState) {
    categories = (state as LoadedCategoryState).categories;
  }
  emit(LoadingCategoryState());
  try {
    final category = await _categoryRepository.addCategories(event.name);
    if (category != null && category['category'] != null) {
      // ignore: avoid_print
      print("Category Add in bloc ${category['category']}");
      categories.add(CategoriesModel.fromJson(category['category']));
      emit(LoadedCategoryState(categories: categories));
    } else {
      throw Exception("Kutilmagan natija: category yoki 'category' null.");
    }
  } catch (e) {
    // ignore: avoid_print
    print("Category qo'shish Bloc : $e");
    emit(ErrorCategoryState(message: e.toString()));
  }
}

}
