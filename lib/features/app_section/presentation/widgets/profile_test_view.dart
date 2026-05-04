import 'package:flutter/material.dart';

class ProfileTestView extends StatelessWidget {
  const ProfileTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple,
      child: const Center(
        child: Text(
          "Profile View",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}