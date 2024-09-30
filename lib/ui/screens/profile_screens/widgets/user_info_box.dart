import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UserInfoBox extends StatelessWidget {
  int recipes;
  int followers;
  int following;
  UserInfoBox({
    super.key,
    required this.followers,
    required this.following,
    required this.recipes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xffD5EEEE),
      ),
      padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 33),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                recipes.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const Text("Recipes")
            ],
          ),
          Column(
            children: [
              Text(
                followers.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const Text("Followers")
            ],
          ),
          Column(
            children: [
              Text(
                following.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const Text("Follows")
            ],
          )
        ],
      ),
    );
  }
}
