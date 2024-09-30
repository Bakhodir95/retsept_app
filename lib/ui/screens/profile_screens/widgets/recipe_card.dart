import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:retsept_app/data/models/food_models.dart';
import 'package:retsept_app/ui/screens/profile_screens/widgets/custom_icon.dart';
import 'package:retsept_app/ui/widgets/recipe_info_screen.dart';
import 'package:retsept_app/ui/widgets/slide_transition.dart';

class RecipeCard extends StatelessWidget {
  final Food recipe;
  final Function()? onTap;
  const RecipeCard({super.key, required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        SlideTransitionRoute(
          page: RecipeInfoScreen(recipe: recipe),
        );
        Navigator.of(context).push(
          SlideTransitionRoute(
            page: RecipeInfoScreen(
              recipe: recipe,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              recipe.imageUrl,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.4,
              height: 250,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(0.6),
            ),
            height: 250,
          ),
          Positioned(
            top: 10,
            right: 20,
            child: CustomIcon(onTap: onTap, icon: Icons.bookmark_border),
          ),
          Positioned(
              bottom: 20,
              right: 10,
              left: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.watch_later_outlined,
                        color: Colors.grey[350],
                        size: 18,
                      ),
                      const Gap(10),
                      Text(
                        "${recipe.cookingTime} minute",
                        style: TextStyle(
                          color: Colors.grey[350],
                        ),
                      ),
                    ],
                  ),
                  const Gap(10),
                  Text(
                    recipe.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
