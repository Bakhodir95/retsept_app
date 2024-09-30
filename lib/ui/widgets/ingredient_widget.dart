
import 'package:flutter/material.dart';

class IngredientField extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController amountController;

  const IngredientField({
    super.key,
    required this.nameController,
    required this.amountController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.teal.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Ingredient name',
                  hintStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Container(
            width: 65,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.teal.shade100,
              borderRadius: BorderRadius.circular(100),
            ),
            child: TextField(
              controller: amountController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Kg',
                hintStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              style: const TextStyle(fontSize: 18, color: Colors.black),
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }
}
