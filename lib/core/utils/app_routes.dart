import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/home/presentation/screens/app_section_view.dart';
import 'package:flower_app/features/home/presentation/screens/best_seller_view.dart';
import 'package:flower_app/features/shopping/presentation/view_models/cart_view_model/cart_view_model.dart';
import 'package:flower_app/features/address/presentation/screens/edit_address_screen.dart';
import 'package:flower_app/features/profile/presentation/view_models/change_password_view_model/change_password_view_model.dart';
import 'package:flower_app/features/profile/presentation/screens/change_password_view.dart';
import 'package:flower_app/features/profile/presentation/screens/edit_profile_view.dart';
import 'package:flower_app/features/home/presentation/view_models/occasions_view_model/occasions_view_model.dart';
import 'package:flower_app/features/home/presentation/screens/occasions_view.dart';
import 'package:flower_app/features/shopping/presentation/screens/product_details_view.dart';
import 'package:flower_app/features/shopping/presentation/view_models/product_details_view_model/product_details_view_model.dart';
import 'package:flower_app/features/splash/presentation/screens/splash_screen.dart';
import '../../features/address/presentation/screens/add_address_screen.dart';
import '../../features/auth/presentation/screens/forget_password_routes.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_view.dart';
import '../../features/address/presentation/screens/saved_address_screen.dart';
import '../../features/address/presentation/view_models/edit_address_view_model/edit_address_view_model.dart';
import '../../features/shopping/presentation/screens/checkout_arguments.dart';
import '../../features/shopping/presentation/screens/checkout_view.dart';
import '../../features/shopping/presentation/screens/orders_screen.dart';
import '../../features/home/presentation/screens/search_screen.dart';

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
        return MaterialPageRoute(builder: (_) => const AddAddressScreen());

      case AppRoutesName.editAddress:
        final address = settings.arguments as AddressEntity;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<EditAddressViewModel>(),
            child: EditAddressScreen(address: address),
          ),
        );

      case AppRoutesName.checkout:
        final arguments = settings.arguments as CheckoutArguments;
        return MaterialPageRoute(
          builder: (_) => CheckoutView(arguments: arguments),
        );

      case AppRoutesName.occasions:
        final occasionId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<CartViewModel>(),
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
            value: getIt<CartViewModel>(),
            child: BlocProvider(
              create: (_) => getIt<ProductDetailsViewModel>(),
              child: ProductDetailsView(productId: productId),
            ),
          ),
        );

      case AppRoutesName.bestSeller:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<CartViewModel>(),
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
      case AppRoutesName.myOrders:
        return MaterialPageRoute(builder: (_) => const OrdersScreen());

      case AppRoutesName.search:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<CartViewModel>(),
            child: const SearchScreen(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text(AppStrings.routeNotFound))),
        );
    }
  }
}
