import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:retsept_app/blocs/retsept_bloc/retsept_bloc.dart';
import 'package:retsept_app/blocs/retsept_bloc/retsept_event.dart';
import 'package:retsept_app/blocs/retsept_bloc/retsept_state.dart';
import 'package:retsept_app/blocs/users_bloc/users_bloc.dart';
import 'package:retsept_app/blocs/users_bloc/users_event.dart';
import 'package:retsept_app/blocs/users_bloc/users_state.dart';
import 'package:retsept_app/data/models/food_models.dart';
import 'package:retsept_app/data/models/user_model.dart';
import 'package:retsept_app/ui/screens/home_screen/widgets/animated_container_indicator.dart';
import 'package:retsept_app/ui/screens/home_screen/widgets/retcept_main_card.dart';
import 'package:retsept_app/ui/screens/profile_screens/screens/profile_screen.dart';
import 'package:retsept_app/ui/screens/profile_screens/widgets/recipe_card.dart';
import 'package:retsept_app/ui/screens/search_screen/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> _currentindexNotifier = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(243, 186, 255, 250),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: BlocBuilder<UsersBloc, UsersState>(
              bloc: context.read<UsersBloc>()..add(GetAuthenticatedUserEvent()),
              builder: (context, state) {
                if (state is AuthenticatedUserLoaded) {
                  UserModels user = state.user;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ));
                        },
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(user.imageUrl),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const SearchScreen();
                            },
                          ));
                        },
                        icon: const Icon(
                          Icons.search,
                          size: 30,
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox(
                  width: 60,
                  height: 60,
                  child: CircleAvatar(),
                );
              },
            ),
          ),
          BlocBuilder<RetseptBloc, RetseptState>(
            bloc: context.read<RetseptBloc>()..add(GetRetseptsEvent()),
            builder: (context, state) {
              if (state is LoadingRetseptState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is ErrorRetseptState) {
                return Center(
                  child: Text(state.message),
                );
              }
              if (state is LoadedRetseptState) {
                List<Food> retcepts = state.retsepts;
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Gap(50),
                        CarouselSlider.builder(
                          itemCount: retcepts.length,
                          itemBuilder: (context, index, realIndex) {
                            if (index < 0 || index >= retcepts.length) {
                              return const Center(child: Text("Invalid index"));
                            }
                            final Food retcept = retcepts[index];
                            return RetceptHomeCard(retcept: retcept);
                          },
                          options: CarouselOptions(
                            onPageChanged: (index, reason) {
                              _currentindexNotifier.value = index;
                            },
                            height: 180,
                            autoPlay: true,
                            viewportFraction: 0.8,
                            enlargeCenterPage: true,
                          ),
                        ),
                        const Gap(15),

                        // Indicator dots
                        ValueListenableBuilder<int>(
                          valueListenable: _currentindexNotifier,
                          builder: (context, currentindex, child) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                retcepts.length,
                                (index) => AnimatedContainerIndicator(
                                  currentindexNotifier: _currentindexNotifier,
                                  index: index,
                                ),
                              ),
                            );
                          },
                        ),
                        const Gap(30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Popular Recipes",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  mainAxisExtent: 250,
                                ),
                                itemCount: retcepts.length,
                                itemBuilder: (context, index) {
                                  Food retsept = retcepts[index];
                                  return RecipeCard(
                                    onTap: () {
                                      // push to about screen
                                    },
                                    recipe: retsept,
                                  );
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }

              return const Center(
                child: Text("Retseptlar mavjud emas"),
              );
            },
          ),
        ],
      ),
    );
  }
}
