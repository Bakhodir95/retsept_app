import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final Function()? onTap;
  final IconData icon;

  const CustomIcon({super.key,required this.onTap,required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2), shape: BoxShape.circle),
        child:  Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
