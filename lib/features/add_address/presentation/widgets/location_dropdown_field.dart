import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flower_app/features/add_address/domain/entities/location_entity.dart';

class AddressLocationJsonParser {
  const AddressLocationJsonParser._();

  static Future<List<LocationEntity>> loadGovernorates() async {
    final jsonData = await _loadJsonData('assets/files/cities.json');

    return jsonData.map((item) {
      return LocationEntity(
        id: item['id'] as String,
        name: item['governorate_name_en'] as String,
      );
    }).toList();
  }

  static Future<List<LocationEntity>> loadCities() async {
    final jsonData = await _loadJsonData('assets/files/states.json');

    return jsonData.map((item) {
      return LocationEntity(
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
        ) as Map<String, dynamic>;

    return (table['data'] as List<dynamic>).cast<Map<String, dynamic>>();
  }
}

class LocationDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<LocationEntity> items;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;

  const LocationDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
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
      validator: validator,
    );
  }
}