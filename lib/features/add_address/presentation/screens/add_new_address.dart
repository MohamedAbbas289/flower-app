import 'package:flutter/material.dart';

import '../../../../core/values/app_strings.dart';
import '../widgets/drop_down_item.dart';
import '../widgets/map.dart';

class AddNewAddress extends StatelessWidget {
   AddNewAddress({super.key});

  final formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController recipientNameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.address),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            spacing: 16,
            children: [
              Container(
                height: size.height*.25,
                color: Colors.pink,
                child: MapSample(),
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: AppStrings.address,
                  hintText: AppStrings.enterTheAddress,
                ),
              ),
              TextFormField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                  labelText: AppStrings.phoneLabel,
                  hintText: AppStrings.enterThePhoneNumber,
                ),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: recipientNameController,
                decoration: InputDecoration(
                  labelText: AppStrings.recipientName,
                  hintText: AppStrings.enterTheRecipientName,
                ),
              ),
              Row(
                children: [
                  Expanded(child: DropDownItem()),
                  SizedBox(width: 16),
                  Expanded(child: DropDownItem()),
                ],
              ),

              SizedBox(
                width: double.infinity,
                  child: ElevatedButton(onPressed: (){},
                      child: Text(AppStrings.saveAddress,))),

            ]),
        ),
      ),

    );
  }
}
