// ignore_for_file: unused_local_variable, avoid_print
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retsept_app/blocs/retsept_bloc/retsept_event.dart';
import 'package:retsept_app/blocs/retsept_bloc/retsept_state.dart';
import 'package:retsept_app/data/models/food_models.dart';
import 'package:retsept_app/data/repositories/retsept_repository.dart';

class RetseptBloc extends Bloc<RetseptEvent, RetseptState> {
  final RetseptRepository _retseptRepository;
  RetseptBloc({
    required RetseptRepository retseptRepository,
  })  : _retseptRepository = retseptRepository,
        super(InitialRetseptState()) {
          
    on<GetRetseptsEvent>(_getRetsept);
    on<AddRetseptEvent>(_addRetsept);
    on<EditRetseptEvent>(_editRetsept);
    on<DeleteRetseptEvent>(_deleteReset);
  }

  void _getRetsept(GetRetseptsEvent event, Emitter emit) async {
    emit(LoadingRetseptState());
    try {
      final retsepts = await _retseptRepository.getRetsepts();
      emit(LoadedRetseptState(retsepts: retsepts));
    } catch (e) {
      emit(ErrorRetseptState(message: e.toString()));
    }
  }

  void _addRetsept(AddRetseptEvent event, Emitter emit) async {
    List<Food> retsepts = [];
    if (state is LoadedRetseptState) {
      retsepts = (state as LoadedRetseptState).retsepts;
    }
    emit(LoadingRetseptState());
    try {
      final Food retseptModel = Food(
        id: "",
        title: event.title,
        userId: event.userId,
        likes: event.likes,
        commits: event.commits,
        videoUrl: event.videoUrl,
        categoryId: event.categoryId,
        cookingTime: event.cookingTime,
        imageUrl: event.imageUrl,
        ingredients: event.ingredients,
      );
      final retsept = await _retseptRepository.addRetsept(retseptModel);
      retsepts.add(retseptModel);
      emit(LoadedRetseptState(retsepts: retsepts));
    } catch (e) {
      print("AddRetsept Bloc: $e");
      emit(ErrorRetseptState(message: e.toString()));
    }
  }

  void _editRetsept(EditRetseptEvent event, Emitter emit) async {
    List<Food> retsepts = [];
    if (state is LoadedRetseptState) {
      retsepts = (state as LoadedRetseptState).retsepts;
    }
    emit(LoadingRetseptState());

    try {
      final Food updatedRetsept = Food(
        id: event.retseptId,
        title: event.title,
        userId: event.userId,
        likes: event.likes,
        commits: [],
        videoUrl: event.videoUrl,
        categoryId: event.categoryId,
        cookingTime: event.cookingTime,
        imageUrl: event.imageUrl,
        ingredients: event.ingredients,
      );

      await _retseptRepository.editRetsept(event.retseptId, updatedRetsept);

      final index =
          retsepts.indexWhere((retsept) => retsept.id == event.retseptId);
      if (index != -1) {
        retsepts[index] = updatedRetsept;
      }

      emit(LoadedRetseptState(retsepts: retsepts));
    } catch (e) {
      print("Error during retsept edit: $e");
      emit(ErrorRetseptState(message: e.toString()));
    }
  }

    void _deleteReset(DeleteRetseptEvent event, Emitter emit) async {
    List<Food> retsepts = [];
    if (state is LoadedRetseptState) {
      retsepts = (state as LoadedRetseptState).retsepts;
    }
    emit(LoadingRetseptState());
    try {
      await _retseptRepository.deleteRetsept(event.id);
      
      retsepts.removeWhere((retsept) => retsept.id == event.id);
      
      emit(LoadedRetseptState(retsepts: retsepts));
    } catch (e) {
      print("Error during retsept delete: $e");
      emit(ErrorRetseptState(message: e.toString()));
    }
  }
}
