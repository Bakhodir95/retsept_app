import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:retsept_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:retsept_app/blocs/user_retsept_bloc/user_retcept_bloc.dart';
import 'package:retsept_app/blocs/user_retsept_bloc/user_retcept_event.dart';
import 'package:retsept_app/blocs/user_retsept_bloc/user_retcept_state.dart';
import 'package:retsept_app/blocs/users_bloc/users_bloc.dart';
import 'package:retsept_app/blocs/users_bloc/users_event.dart';
import 'package:retsept_app/blocs/users_bloc/users_state.dart';
import 'package:retsept_app/data/models/food_models.dart';
import 'package:retsept_app/service/retsept_dio_service.dart';
import 'package:retsept_app/ui/screens/auth_screen/screens/initial_screen.dart';
import 'package:retsept_app/ui/screens/profile_screens/widgets/custom_icon.dart';
import 'package:retsept_app/ui/screens/profile_screens/widgets/recipe_card.dart';
import 'package:retsept_app/ui/screens/profile_screens/widgets/user_info_box.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final RetseptService retseptService = RetseptService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(130, 186, 255, 250),
      body: BlocBuilder<UsersBloc, UsersState>(
        bloc: context.read<UsersBloc>()..add(GetAuthenticatedUserEvent()),
        builder: (context, state) {
          if (state is UsersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuthenticatedUserLoaded) {
            final user = state.user;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset(
                        "assets/profile_images/profile_bg.png",
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 30,
                        left: 30,
                        right: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomIcon(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icons.arrow_back_ios_new),
                            CustomIcon(
                              onTap: () {
                                context.read<AuthBloc>().add(LogoutEvent());
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const InitialScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                              icon: Icons.logout,
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: -50,
                        left: MediaQuery.of(context).size.width / 2.7,
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          width: 116,
                          height: 135,
                          child: Image.network(
                            user.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 33, vertical: 60),
                    child: Column(
                      children: [
                        Text(
                          user.userName,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff3FB4B1)),
                        ),
                        const Gap(15),
                        UserInfoBox(
                          followers: user.followers.length,
                          following: user.follows.length,
                          recipes:
                              24, // Update this to reflect the actual count
                        ),
                        // Gap(100),
                        BlocBuilder<UserRetseptBloc, UserRetseptState>(
                          bloc: context.read<UserRetseptBloc>()
                            ..add(
                              GetUserRetseptEvent(),
                            ),
                          builder: (context, state) {
                            if (state is LoadingUserRetseptState) {
                              return const Column(
                                children: [
                                  Gap(100),
                                  Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ],
                              );
                            }

                            if (state is ErrorUserRetseptState) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(state.message),
                                  );
                                },
                              );
                            }
                            if (state is LoadedUserRetseptState) {
                              final List<Food> retsepts = state.retsepts;

                              return retsepts.isNotEmpty
                                  ? GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        mainAxisExtent: 250,
                                      ),
                                      itemCount: retsepts.length,
                                      itemBuilder: (context, index) {
                                        Food retsept = retsepts[index];
                                        return RecipeCard(
                                            onTap: () {}, recipe: retsept);
                                      },
                                    )
                                  : Lottie.asset(
                                      "assets/profile_images/animation1.json");
                            }
                            return const Center(
                              child: Text("Retseptlar mavjud emas"),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is UsersError) {
            return Center(child: Text("Error: ${state.message}"));
          } else {
            return const Center(child: Text("No user found."));
          }
        },
      ),
    );
  }
}
