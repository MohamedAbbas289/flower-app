import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {

  static const routeName = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Center(
              child: Text('Welcome to the Home Screen!'),

            ),
            TextFormField(),
            ElevatedButton(onPressed: (){}, child: Text('Login')),
          ],
        ),
      ),
    );
  }
}
