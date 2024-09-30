// lib/screens/account_setup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:retsept_app/blocs/accounts_setup_bloc/accounts_setup_bloc.dart';
import 'package:retsept_app/blocs/accounts_setup_bloc/accounts_setup_event.dart';
import 'package:retsept_app/blocs/accounts_setup_bloc/accounts_setup_state.dart';
import 'package:retsept_app/service/users_dio_service.dart';
import 'package:retsept_app/ui/screens/account_setup_screens/screens/setup_completed_screen.dart';
import 'package:retsept_app/ui/widgets/leading_button.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class AccountSetupScreen extends StatefulWidget {
  const AccountSetupScreen({super.key});

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  final TextEditingController userNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final userName = userNameController.text;
      final currentState = context.read<AccountSetupBloc>().state;

      if (currentState is AccountSetupImagePicked) {
        final imageFile = currentState.imageFile;

        // Trigger image upload
        context.read<AccountSetupBloc>().add(UploadImageEvent(imageFile));

        // Listen for the upload completion only once
        context
            .read<AccountSetupBloc>()
            .stream
            .firstWhere((state) => state is AccountSetupImageUploaded)
            .then((state) {
          if (state is AccountSetupImageUploaded &&
              // ignore: unnecessary_null_comparison
              state.imageUrl != null &&
              state.imageUrl.isNotEmpty) {
            final imageUrl = state.imageUrl;

            // Proceed with form submission
            UsersDioService usersDioService = UsersDioService();
            usersDioService.addUser(userName, imageUrl);

            // Trigger the form submission event
            context
                .read<AccountSetupBloc>()
                .add(SubmitFormEvent(userName, imageFile, imageUrl));

            // Navigate to HomeScreen
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const SetupCompletedScreen(),
            ));
          } else {
            // Handle the case where the imageUrl is null or empty
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Color(0xFF37B4C3),
                content: Text('Image upload failed. Please try again.'),
              ),
            );
          }
        });
      } else {
        // Show an error message if no image is selected
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF37B4C3),
            content: Text('Please select a profile picture.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: Image.asset(
              "assets/auth_image/top_left.png",
              height: MediaQuery.of(context).size.height / 2,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(50),
                  const LeadingButton(radius: 25),
                  const Gap(20),
                  const Text(
                    "Account\nSetup",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 36,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Gap(40),
                  Expanded(
                    child: BlocBuilder<AccountSetupBloc, AccountSetupState>(
                      builder: (context, state) {
                        if (state is AccountSetupLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is AccountSetupImagePicked) {
                          return ZoomTapAnimation(
                            onTap: () {
                              context.read<AccountSetupBloc>().add(
                                  const PickImageEvent(ImageSource.gallery));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 75),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE2F6F5),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: FileImage(state.imageFile),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return ZoomTapAnimation(
                            onTap: () {
                              context.read<AccountSetupBloc>().add(
                                  const PickImageEvent(ImageSource.gallery));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFE2F6F5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.upload_outlined,
                                    ),
                                    Gap(10),
                                    Text(
                                      "Upload your profile picture",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Gap(5),
                                    Text(
                                      "*maximum size 2MB",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const Gap(20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your username";
                      }
                      return null;
                    },
                    controller: userNameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle:
                          const TextStyle(color: Colors.black, fontSize: 14),
                      filled: true,
                      fillColor: const Color(0xFFE2F6F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onSubmit,
                      // onPressed: () {
                      //   UsersDioService usersDioService = UsersDioService();
                      //   usersDioService.addUser("Feruza", "imageUrl");
                      // },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF37B4C3),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const Gap(14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
