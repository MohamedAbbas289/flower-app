import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/add_address/domain/entities/address_entity.dart';
import 'package:flower_app/features/app_section/presentation/view/app_section_view.dart';
import 'package:flower_app/features/best_seller/presentation/view/best_seller_view.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_bloc.dart';
import 'package:flower_app/features/edit_address/presentation/screens/edit_address_screen.dart';
import 'package:flower_app/features/edit_profile/presentation/pages/edit_profile_view.dart';
import 'package:flower_app/features/occasions/presentation/occasions_view_model/occasions_view_model.dart';
import 'package:flower_app/features/occasions/presentation/pages/occasions_view.dart';
import 'package:flower_app/features/change_password/presentation/pages/change_password_view.dart';
import 'package:flower_app/features/change_password/presentation/change_password_view_model/cubit/change_password_view_model.dart';
import 'package:flower_app/features/splash/presentation/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flower_app/features/product_details/presentation/pages/product_details_view.dart';
import 'package:flower_app/features/product_details/presentation/view_model/product_details_cubit.dart';
import '../../features/add_address/presentation/screens/add_new_address.dart';
import '../../features/auth/forget-password/presentation/flow/forget_password_routes.dart';
import '../../features/auth/login/presentation/screens/login_screen.dart';
import '../../features/auth/signup/presentation/pages/signup_view.dart';
import '../../features/saved_address/presentation/screens/saved_address_screen.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final forgetPasswordRoute = ForgetPasswordRoutes.onGenerateRoute(settings);
    if (forgetPasswordRoute != null) return forgetPasswordRoute;

    switch (settings.name) {
      case AppRoutesName.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutesName.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutesName.home:
        return MaterialPageRoute(builder: (_) => const AppSectionView());
      case AppRoutesName.signUp:
        return MaterialPageRoute(builder: (_) => const SignupView());
      case AppRoutesName.savedAddress:
        return MaterialPageRoute(builder: (_) => SavedAddressScreen());

      case AppRoutesName.addAddress:
        return MaterialPageRoute(builder: (_) => AddNewAddress());
      case AppRoutesName.editAddress:
        final address = settings.arguments as AddressEntity;
        return MaterialPageRoute(
          builder: (_) => EditAddressScreen(address: address),
        );

      case AppRoutesName.occasions:
        final occasionId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<CartBloc>(),
            child: BlocProvider(
              create: (_) => getIt<OccasionsViewModel>(),
              child: OccasionsView(initialOccasionId: occasionId),
            ),
          ),
        );

      case AppRoutesName.productDetails:
        final productId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<CartBloc>(),
            child: BlocProvider(
              create: (_) => getIt<ProductDetailsCubit>(),
              child: ProductDetailsView(productId: productId),
            ),
          ),
        );

      case AppRoutesName.bestSeller:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<CartBloc>(),
            child: const BestSellerView(),
          ),
        );

      case AppRoutesName.changePassword:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ChangePasswordViewModel>(),
            child: Builder(builder: (context) => const ChangePasswordView()),
          ),
        );

      case AppRoutesName.editProfile:
        final authData = settings.arguments as AuthResponseEntity;
        return MaterialPageRoute(
          builder: (_) => EditProfileView(initialData: authData),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text(AppStrings.routeNotFound))),
        );
    }
  }
}
