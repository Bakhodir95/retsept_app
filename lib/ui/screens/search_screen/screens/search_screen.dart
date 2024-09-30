import 'dart:async';
import 'package:flutter/material.dart';
import 'package:retsept_app/data/models/food_models.dart';
import 'package:retsept_app/service/retsept_dio_service.dart';
import 'package:retsept_app/ui/screens/profile_screens/widgets/recipe_card.dart';
import 'package:retsept_app/ui/screens/search_screen/widgets/searcviewdelegate.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Timer? request;
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();
  final RetseptService retseptDio = RetseptService();
  List<Food> recipes = [];

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  @override
  void dispose() {
    request?.cancel();
    searchController.dispose();
    super.dispose();
  }

  void fetchRecipes() async {
    try {
      final List<Food> data = await retseptDio.getRetsept();
      setState(() {
        recipes = data;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching recipes: $error')),
      );
    }
  }

  void showRecipeSearch() {
    showSearch(
      context: context,
      delegate: SearchDelegateWidget(recipes),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(225, 186, 255, 250),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(13, 186, 255, 250),
        title: const Text('Recipe Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onTap: () {
                      showRecipeSearch();
                    },
                    decoration: const InputDecoration(
                      labelText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: recipes.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          mainAxisExtent: 250,
                        ),
                        itemCount: recipes.length,
                        itemBuilder: (context, index) {
                          Food retsept = recipes[index];
                          return RecipeCard(
                            onTap: () {
                              // push to about screen
                            },
                            recipe: retsept,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
