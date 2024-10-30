import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  CategoryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: TextButton(
        onPressed: onTap,
        child: Text(label, style: TextStyle(fontSize: 18.0, color: Colors.black)),
      ),
    );
  }
}
