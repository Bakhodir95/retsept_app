// lib/blocs/account_setup/account_setup_state.dart


import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class AccountSetupState extends Equatable {
  const AccountSetupState();

  @override
  List<Object?> get props => [];
}

class AccountSetupInitial extends AccountSetupState {}

class AccountSetupLoading extends AccountSetupState {}

class AccountSetupImagePicked extends AccountSetupState {
  final File imageFile;

  const AccountSetupImagePicked(this.imageFile);
}

class AccountSetupImageUploaded extends AccountSetupState {
  final String imageUrl;

  const AccountSetupImageUploaded(this.imageUrl);
}

class AccountSetupSubmitted extends AccountSetupState {
  final String userName;
  final String imageUrl;

  const AccountSetupSubmitted(this.userName, this.imageUrl);
}

class AccountSetupError extends AccountSetupState {
  final String errorMessage;

  const AccountSetupError(this.errorMessage);
}
