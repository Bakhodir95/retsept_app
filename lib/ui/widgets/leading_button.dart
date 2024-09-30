import 'package:flutter/material.dart';

class LeadingButton extends StatelessWidget {
  final double radius;
  const LeadingButton({super.key,required this.radius});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child:  CircleAvatar(
        radius: radius,
        backgroundColor: const Color(0xff86D5D3),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
