import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:retsept_app/blocs/retsept_bloc/retsept_bloc.dart';
import 'package:retsept_app/blocs/retsept_bloc/retsept_event.dart';
import 'package:retsept_app/data/models/food_models.dart';
import 'package:retsept_app/data/models/ingredient_model.dart';
import 'package:retsept_app/ui/screens/add_recipe_screens/edit_recipe_screen.dart';

class RecipeInfoScreen extends StatefulWidget {
  final Food recipe;
  const RecipeInfoScreen({super.key, required this.recipe});

  @override
  State<RecipeInfoScreen> createState() => _RecipeInfoScreenState();
}

class _RecipeInfoScreenState extends State<RecipeInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            stretch: true,
            expandedHeight: 350,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.network(
                    widget.recipe.imageUrl,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  Container(
                    height: 500,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: const Color(0xff3FB4B1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.recipe.categoryId,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const Gap(15),
                        Text(
                          widget.recipe.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: "Roboto",
                          ),
                        ),
                        const Gap(15),
                        Row(
                          children: [
                            Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Gap(10),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 60,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${widget.recipe.cookingTime} minutes",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              context.read<RetseptBloc>().add(
                                                    DeleteRetseptEvent(
                                                      id: widget.recipe.id,
                                                    ),
                                                  );
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                              size: 26,
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return EditRecipeScreen(
                                                retsept: widget.recipe,
                                              );
                                            },
                                          ));
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color:
                                              Color.fromARGB(227, 33, 149, 243),
                                          size: 26,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Container(
                clipBehavior: Clip.hardEdge,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey.withOpacity(0.7),
                ),
                child: const Icon(
                  CupertinoIcons.back,
                  color: Colors.white,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},  
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey.withOpacity(0.4),
                  ),
                  child: const Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 0),
            sliver: SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(40, 251, 248, 248),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "INGREDIENTLAR!",
                      style: TextStyle(
                        fontSize: 30,
                        color: Color.fromARGB(254, 166, 185, 244),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: ListView.builder(
                        itemCount: widget.recipe.ingredients.length,
                        itemBuilder: (context, index) {
                          IngredientModel ingredient =
                              widget.recipe.ingredients[index];
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: Center(
                              child: Text(
                                "<--   ${ingredient.title}   -->",
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Color.fromARGB(193, 5, 232, 213),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
