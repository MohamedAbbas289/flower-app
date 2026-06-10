import 'package:flutter/material.dart';

import '../../../../core/values/app_routes_name.dart';
import '../../../../core/values/app_strings.dart';
import '../widgets/saved_address_item.dart';

class SavedAddressScreen extends StatelessWidget {
  const SavedAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Row(
        children: [
          Text(AppStrings.savedAddress),
        ],
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SavedAddressItem(),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: (){
                  Navigator.pushNamed(context, AppRoutesName.addresses);

                }, child: Text("Add New Address"))),
          ]
        ),
      ),

    );
  }
}
