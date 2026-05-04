import 'package:flutter/material.dart';

class CategoriesTestView extends StatelessWidget {
  const CategoriesTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Colors.green,
      child: Center(
        child: Text(
          "Categories View",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}