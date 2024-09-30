// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:retsept_app/data/models/food_models.dart';
import 'package:retsept_app/ui/widgets/recipe_info_screen.dart';
import 'package:retsept_app/ui/widgets/slide_transition.dart';

class RetceptHomeCard extends StatelessWidget {
  Food retcept;
  RetceptHomeCard({
    super.key,
    required this.retcept,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          SlideTransitionRoute(
            page: RecipeInfoScreen(recipe: retcept,),
          ),
        );
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              retcept.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 180,
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(0.6),
            ),
            height: 180,
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: const Color(0xff3FB4B1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                retcept.categoryId,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  retcept.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.amber,
    );
  }
}
