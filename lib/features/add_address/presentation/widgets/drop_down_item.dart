import 'package:flutter/material.dart';

class DropDownItem extends StatefulWidget {
  const DropDownItem({super.key});

  @override
  State<DropDownItem> createState() => _DropDownItemState();
}

class _DropDownItemState extends State<DropDownItem> {
  final List<String> cities = [
    'Cairo',
    'Giza',
    'Alex',
    'Aswan',
  ];

  String selectedCity = 'Cairo';
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      initialValue: selectedCity,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'City',
      ),

      items: cities.map((city) {
        return DropdownMenuItem(
          value: city,
          child: Text(city),
        );
      }).toList(),

      onChanged: (value) {
        setState(() {
          selectedCity = value!;
        });
      },
    );
  }
}
