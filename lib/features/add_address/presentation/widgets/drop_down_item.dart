import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocationOption {
  final String id;
  final String name;
  final String? governorateId;

  const LocationOption({
    required this.id,
    required this.name,
    this.governorateId,
  });
}

class AddressJsonLoader {
  const AddressJsonLoader._();

  static Future<List<LocationOption>> loadGovernorates() async {
    final jsonData = await _loadJsonData('assets/files/cities.json');

    return jsonData.map((item) {
      return LocationOption(
        id: item['id'] as String,
        name: item['governorate_name_en'] as String,
      );
    }).toList();
  }

  static Future<List<LocationOption>> loadCities() async {
    final jsonData = await _loadJsonData('assets/files/states.json');

    return jsonData.map((item) {
      return LocationOption(
        id: item['id'] as String,
        name: item['city_name_en'] as String,
        governorateId: item['governorate_id'] as String,
      );
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> _loadJsonData(String path) async {
    final response = await rootBundle.loadString(path);
    final decoded = json.decode(response) as List<dynamic>;
    final table =
        decoded.firstWhere(
              (item) => item is Map<String, dynamic> && item['type'] == 'table',
            )
            as Map<String, dynamic>;

    return (table['data'] as List<dynamic>).cast<Map<String, dynamic>>();
  }
}

class DropDownItem extends StatelessWidget {
  final String label;
  final String? value;
  final List<LocationOption> items;
  final ValueChanged<String?> onChanged;

  const DropDownItem({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      initialValue: value,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(value: item.id, child: Text(item.name));
      }).toList(),
      onChanged: items.isEmpty ? null : onChanged,
    );
  }
}
