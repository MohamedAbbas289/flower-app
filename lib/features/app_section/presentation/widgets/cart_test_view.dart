import 'package:flutter/material.dart';

class CartTestView extends StatelessWidget {
  const CartTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: const Center(
        child: Text(
          "Cart View",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}