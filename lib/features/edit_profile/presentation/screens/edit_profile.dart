import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/di/di.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/validation/app_validations.dart';
import '../../../../core/values/app_strings.dart';
import '../view_models/cubit/edit_profile_view_model.dart';
import '../view_models/states/edit_profile_events.dart';
import '../widgets/change_profile_screen.dart';
import '../widgets/gender_option.dart';

class EditProfile extends StatelessWidget {
   EditProfile({super.key, });

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(AppStrings.editProfile,
                style: TextStyles.appBarTextStyle,),
              Spacer(),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_none_sharp, size: 30),

                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Center(
                        child: Text(
                          '3',
                          style: TextStyles.appBarTextStyle.copyWith(
                            color: AppColors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 4),

            ],
          ),
        ),


      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocProvider(
          create: (_) =>
          getIt<EditProfileViewModel>()..doEvent(const LoadUpdateProfileDataEvent()),
          child: Form(
            key: formKey,
            child: Column(
              spacing: 20,
              children: [
                ChangeProfileScreen(),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          return AppValidations.validateFirstName(value ?? '');
                        },
                        controller: firstNameController,
                        decoration: InputDecoration(
                          labelText: AppStrings.firstNameLabel,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          return AppValidations.validateLastName(value ?? '');
                        },
                        controller: lastNameController,
                        decoration: InputDecoration(
                          labelText: AppStrings.lastNameLabel,
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  validator: (value) {
                    return AppValidations.validateEmail(value ?? '');
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: AppStrings.emailLabel,
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    return AppValidations.validatePhone(value ?? '');
                  },
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    labelText: AppStrings.phoneLabel,
                  ),
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppStrings.passwordLabel,
                    hint: Row(
                      children: [
                        Text('********',
                        style: TextStyles.bodyRegular18,),
                        Spacer(),
                        InkWell(
                          onTap: (){

                          },
                          child: Text(AppStrings.change,
                          style: TextStyles.bodyRegular12.copyWith(
                            color: AppColors.pink,
                          )),
                        )
                      ],
                    )
                  ),
                ),
                Row(
                  children: [
                    Text(AppStrings.genderLabel, style: TextStyles.bodyRegular16),

                    Expanded(
                      child: GenderOption(
                        gender: AppStrings.femaleLabel,
                        selectedGender: 'female',

                        onChanged: (String value) {  },
                      ),
                    ),
                    Expanded(
                      child: GenderOption(
                        gender: AppStrings.maleLabel,
                        selectedGender: 'Male',

                        onChanged: (String value) {  },
                      ),
                    ),




                  ],
                ),
                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(

                      onPressed: (){
                        if(formKey.currentState!.validate()){

                        }

                  }, child: Text(AppStrings.update)),
                ),



              ]
            ),
          ),
        ),
      ),

    );
  }
}
