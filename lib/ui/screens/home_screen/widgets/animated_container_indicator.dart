import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AnimatedContainerIndicator extends StatelessWidget {
  ValueNotifier<int> currentindexNotifier;
  int index;
  AnimatedContainerIndicator(
      {super.key, required this.currentindexNotifier, required this.index});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: currentindexNotifier.value == index ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: currentindexNotifier.value == index
            ? const Color(0xff3FB4B1)
            : Colors.grey,
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }
}
