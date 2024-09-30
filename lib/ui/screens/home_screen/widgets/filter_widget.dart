import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FilterWidget extends StatelessWidget {
  String selectedCategory = "Breakfast";
  String time = "The Newest";

  FilterWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xff3FB4B1)),
      child: IconButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  void updateSelectedCategory(
                    String category,
                  ) {
                    setState(() {
                      selectedCategory = category;
                    });
                  }

                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Category",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    updateSelectedCategory("Breakfast"),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, right: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: selectedCategory == "Breakfast"
                                          ? const Color(0xff3FB4B1)
                                          : Colors.grey,
                                    ),
                                    child: const Text("Breakfast"),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => updateSelectedCategory("Lunch"),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, right: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: selectedCategory == "Lunch"
                                          ? const Color(0xff3FB4B1)
                                          : Colors.grey,
                                    ),
                                    child: const Text("Lunch"),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => updateSelectedCategory("Dinner"),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, right: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: selectedCategory == "Dinner"
                                          ? const Color(0xff3FB4B1)
                                          : Colors.grey,
                                    ),
                                    child: const Text("Dinner"),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => updateSelectedCategory("Sweets"),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, right: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: selectedCategory == "Sweets"
                                          ? const Color(0xff3FB4B1)
                                          : Colors.grey,
                                    ),
                                    child: const Text("Sweets"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            "Time",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    updateSelectedCategory("The Newest"),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, right: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: selectedCategory == "The Newest"
                                          ? const Color(0xff3FB4B1)
                                          : Colors.grey,
                                    ),
                                    child: const Text("The Newest"),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    updateSelectedCategory("The Oldest"),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, right: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: selectedCategory == "The Oldest"
                                          ? const Color(0xff3FB4B1)
                                          : Colors.grey,
                                    ),
                                    child: const Text("The Oldest"),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    updateSelectedCategory("Popularity"),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, right: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: selectedCategory == "Popularity"
                                          ? const Color.fromARGB(255, 13, 225, 133)
                                          : Colors.grey,
                                    ),
                                    child: const Text("Popularity"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        icon: const Icon(
          Icons.format_list_bulleted_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
