import 'package:flutter/material.dart';

class HomeTestView extends StatelessWidget {
  const HomeTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: const Center(
        child: Text(
          "Home View",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}