// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:retsept_app/blocs/category_bloc/category_bloc.dart';
import 'package:retsept_app/blocs/retsept_bloc/retsept_bloc.dart';
import 'package:retsept_app/blocs/retsept_bloc/retsept_event.dart';
import 'package:retsept_app/blocs/retsept_bloc/retsept_state.dart';
import 'package:retsept_app/data/models/food_models.dart';
import 'package:retsept_app/data/models/ingredient_model.dart';
import 'package:retsept_app/ui/widgets/ingredient_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class EditRecipeScreen extends StatefulWidget {
  final Food retsept;
  const EditRecipeScreen({super.key, required this.retsept});

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  late TextEditingController titleController;
  late TextEditingController imageUrlController;
  final List<TextEditingController> _nameControllers = [];
  final List<TextEditingController> _amountControllers = [];
  List<IngredientModel> ingredients = [];
  final pageController = PageController();

  final formKey = GlobalKey<FormState>();
  int currentPage = 0;
  late int _cookTime;
  late String category;

  File? _imageFile;

  Future<String?> getUser() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final String? userData = sharedPreferences.getString('userData');

    if (userData == null) {
      return null;
    }

    final Map<String, dynamic> userMap = jsonDecode(userData);
    final User user = User.fromJson(userMap);
    return user.id;
  }

  Future<void> pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: source,
      imageQuality: 30,
      requestFullMetadata: false,
    );
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> uploadImage() async {
    if (_imageFile == null) return;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images/${DateTime.now().toString()}.jpg');
      final uploadTask = storageRef.putFile(_imageFile!);

      final snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();
      imageUrlController.text = imageUrl;
    } catch (e) {
      print('Imgeni Yuklashda xatolik: $e');
    }
  }

  void submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      await uploadImage();

      try {
        if (titleController.text.isNotEmpty &&
            imageUrlController.text.isNotEmpty) {
          nextPage();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Image Yuklanmagan!"),
            ),
          );
        }
      } catch (e) {
        print("Error Image va Title Yuklashda");
      }
    }
  }

  void _addIngredient() {
    setState(() {
      _nameControllers.add(TextEditingController());
      _amountControllers.add(TextEditingController());
      ingredients.add(IngredientModel(amount: "", title: ""));
    });
  }

  void _saveIngredients() {
    for (int i = 0; i < ingredients.length; i++) {
      ingredients[i].title = _nameControllers[i].text;
      ingredients[i].amount = _amountControllers[i].text;
    }
    if (ingredients.isEmpty ||
        ingredients[0].amount.isEmpty ||
        ingredients[0].title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ingredientlar Yuklanmagan!"),
        ),
      );
    } else {
      nextPage();
      print(
          "Saved Ingredients: ${ingredients.map((e) => '${e.title}: ${e.amount}').join(', ')}");
    }
  }

  void nextPage() {
    if (currentPage < 2) {
      pageController.animateToPage(
        currentPage + 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      pageController.animateToPage(
        currentPage - 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    for (var controller in _amountControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.retsept.title);
    imageUrlController = TextEditingController(text: widget.retsept.imageUrl);

    ingredients = widget.retsept.ingredients;
    for (var i = 0; i < widget.retsept.ingredients.length; i++) {
      _nameControllers.add(
        TextEditingController(text: widget.retsept.ingredients[i].title),
      );
      _amountControllers.add(
        TextEditingController(text: widget.retsept.ingredients[i].amount),
      );
    }

    _cookTime = widget.retsept.cookingTime;
    category = widget.retsept.categoryId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.teal,
        title: const Text(
          'Add Recipe',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.teal.shade100,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Text(
                "${(currentPage + 1).toString()}/3",
                style: const TextStyle(
                  color: Color.fromARGB(255, 14, 4, 4),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 20,
        ),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: (value) {
            setState(() {
              currentPage = value;
            });
          },
          children: [
            _titleImageAdd(),
            _ingredientAdd(),
            _buildInformationStep(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ZoomTapAnimation(
              onTap: () {
                previousPage();
              },
              child: Container(
                width: 56,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromARGB(208, 99, 223, 219),
                ),
                child: const Center(child: Icon(Icons.arrow_back)),
              ),
            ),
            BlocBuilder<RetseptBloc, RetseptState>(
              builder: (context, state) {
                if (state is LoadingRetseptState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is LoadedRetseptState) {
                  return ZoomTapAnimation(
                    onTap: () async {
                      if (currentPage == 0) {
                        submit();
                      }
                      if (currentPage == 1) {
                        _saveIngredients();
                      }
                      if (currentPage == 2) {
                        // ignore: unused_local_variable
                        final userId = await getUser();
                        if (category == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Category Tanlanmagan!"),
                            ),
                          );
                        } else {
                          context.read<RetseptBloc>().add(
                                EditRetseptEvent(
                                  retseptId: widget.retsept.id,
                                  userId: widget.retsept.userId,
                                  title: titleController.text,
                                  likes: 0,
                                  imageUrl: imageUrlController.text,
                                  videoUrl: "",
                                  cookingTime: _cookTime,
                                  ingredients: ingredients,
                                  categoryId: category,
                                ),
                              );
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: Container(
                      width: 180,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xff3FB4B1),
                      ),
                      child: const Center(
                        child: Text(
                          "Next",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _titleImageAdd() {
    return Form(
      key: formKey,
      child: SizedBox(
        height: 250,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Title',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter food title";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 350,
                child: ZoomTapAnimation(
                  onTap: () async {
                    await pickImage(ImageSource.gallery);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.teal[50],
                        borderRadius: BorderRadius.circular(10),
                        image: _imageFile != null
                            ? DecorationImage(
                                image: FileImage(_imageFile!),
                                fit: BoxFit.cover,
                              )
                            : DecorationImage(
                                image: NetworkImage(imageUrlController.text),
                                fit: BoxFit.cover,
                              ),
                      ),
                      child: _imageFile == null
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.upload,
                                      size: 40, color: Colors.black54),
                                  SizedBox(height: 16),
                                  Text(
                                    'Upload your profile picture',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ingredientAdd() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ingredients',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                return IngredientField(
                  nameController: _nameControllers[index],
                  amountController: _amountControllers[index],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _addIngredient,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.teal.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal, width: 2),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.black),
                  SizedBox(width: 8),
                  Text(
                    'Add Ingredients',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationStep() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Information',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 30.0),
          _buildTimeInput('Cooking Time (minute)', _cookTime, (value) {
            setState(() {
              _cookTime = value;
            });
          }),
          const SizedBox(height: 20),
          // ZoomTapAnimation(
          //   onTap: () {
          //     showDialog(
          //       context: context,
          //       builder: (context) => const AlertDialogAddEdit(
          //         isAdd: true,
          //         categoryid: 0,
          //       ),
          //     );
          //   },
          //   child: Container(
          //     width: double.infinity,
          //     height: 40,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(12),
          //       color: const Color(0xff3FB4B1),
          //     ),
          //     child: const Center(
          //       child: Text(
          //         "AddCategory",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 16,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(height: 20.0),
          BlocBuilder<CategoryBloc, CategoryState>(
            bloc: context.read<CategoryBloc>()..add(GetCategoryEvent()),
            builder: (context, state) {
              if (state is LoadingCategoryState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is ErrorCategoryState) {
                return Center(
                  child: Text("Error: ${state.message}"),
                );
              }
              if (state is LoadedCategoryState) {
                if (state.categories.isEmpty) {
                  return const Center(
                    child: Text(
                      "Categoriyalar mavjud emas...",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: SizedBox(
                    child: MasonryGridView.builder(
                      itemCount: state.categories.length,
                      gridDelegate:
                          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: ZoomTapAnimation(
                            onTap: () {
                              category =
                                  state.categories[index].name.toString();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                color: const Color.fromARGB(208, 38, 144, 135),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 7,
                                    bottom: 7,
                                  ),
                                  child: Text(
                                    state.categories[index].name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
              return const Center(
                child: Text("Categoriyalar mavjud emas"),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInput(String label, int value, Function(int) onChange) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Row(
          children: [
            IconButton(
              onPressed: () {
                if (value > 0) onChange(value - 1);
              },
              icon: const Icon(Icons.remove),
              color: Colors.black,
              padding: const EdgeInsets.all(12),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Center(
                child: Text(
                  '$value',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                onChange(value + 1);
              },
              icon: const Icon(Icons.add),
              color: Colors.black,
              padding: const EdgeInsets.all(12),
            ),
          ],
        ),
      ],
    );
  }
}
