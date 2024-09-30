

import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class AccountSetupEvent extends Equatable {
  const AccountSetupEvent();

  @override
  List<Object?> get props => [];
}

class PickImageEvent extends AccountSetupEvent {
  final ImageSource source;

  const PickImageEvent(this.source);
}

class UploadImageEvent extends AccountSetupEvent {
  final File? imageFile;

  const UploadImageEvent(this.imageFile);
}

class SubmitFormEvent extends AccountSetupEvent {
  final String userName;
  final File? imageFile;
  final String imageUrl;

  const SubmitFormEvent(this.userName, this.imageFile, this.imageUrl);
}

