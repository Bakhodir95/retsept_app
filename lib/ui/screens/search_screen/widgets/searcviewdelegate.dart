import 'package:flutter/material.dart';
import 'package:retsept_app/data/models/food_models.dart';
import 'package:retsept_app/ui/widgets/recipe_info_screen.dart';
import 'package:retsept_app/ui/widgets/slide_transition.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class SearchDelegateWidget extends SearchDelegate {
  final List<Food> searchItems;

  SearchDelegateWidget(this.searchItems);

  @override
  Widget buildSuggestions(BuildContext context) => _buildFoundRecipes();

  @override
  Widget buildResults(BuildContext context) => _buildFoundRecipes();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  Widget _buildFoundRecipes() {
    List<Food> suggestions = searchItems.where((item) {
      return item.title.toLowerCase().contains(query.toLowerCase()) ||
          item.cookingTime.toString().contains(query);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ZoomTapAnimation(
          onTap: () {
            Navigator.of(context).push(
              SlideTransitionRoute(
                page: RecipeInfoScreen(
                  recipe: searchItems[index],
                ),
              ),
            );
          },
          child: Container(
            height: 100,
            margin: const EdgeInsets.all(10),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(130, 186, 255, 250),
            ),
            child: Row(
              children: [
                Image.network(
                  suggestions[index].imageUrl,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(suggestions[index].title),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Preporation time',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      '${suggestions[index].cookingTime} minutes',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
