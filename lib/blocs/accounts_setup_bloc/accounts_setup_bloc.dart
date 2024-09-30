// lib/blocs/account_setup/account_setup_bloc.dart
// lib/blocs/account_setup/account_setup_bloc.dart
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:retsept_app/blocs/accounts_setup_bloc/accounts_setup_event.dart';
import 'package:retsept_app/blocs/accounts_setup_bloc/accounts_setup_state.dart';
import 'package:retsept_app/service/photo_upload_storage_service.dart';

class AccountSetupBloc extends Bloc<AccountSetupEvent, AccountSetupState> {
  final ImagePicker imagePicker;
  final PhotoCloudStorageService photoCloudStorageService;

  AccountSetupBloc({
    required this.imagePicker,
    required this.photoCloudStorageService,
  }) : super(AccountSetupInitial()) {
    on<PickImageEvent>(_onPickImage);
    on<UploadImageEvent>(_onUploadImage);
    on<SubmitFormEvent>(_onSubmitForm);
  }

  Future<void> _onPickImage(
      PickImageEvent event, Emitter<AccountSetupState> emit) async {
    final XFile? pickedImage = await imagePicker.pickImage(
      source: event.source,
      imageQuality: 30,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      emit(AccountSetupImagePicked(File(pickedImage.path)));
    } else {
      emit(const AccountSetupError("Image picking failed."));
    }
  }

  Future<void> _onUploadImage(
      UploadImageEvent event, Emitter<AccountSetupState> emit) async {
    if (event.imageFile == null) {
      emit(const AccountSetupError("No image selected."));
      return;
    }

    try {
      final imageUrl = await photoCloudStorageService.uploadImage(event.imageFile!);
      emit(AccountSetupImageUploaded(imageUrl));
    } catch (e) {
      emit(AccountSetupError(e.toString()));
    }
  }

  Future<void> _onSubmitForm(
      SubmitFormEvent event, Emitter<AccountSetupState> emit) async {
    if (event.userName.isEmpty) {
      emit(const AccountSetupError("Username cannot be empty."));
      return;
    }

    emit(AccountSetupLoading());

    if (event.imageFile != null) {
      add(UploadImageEvent(event.imageFile!));
    } else {
      emit(AccountSetupSubmitted(event.userName, event.imageUrl));
    }
  }
}
