import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/app_section/presentation/view/app_section_view.dart';
import 'package:flower_app/features/best_seller/presentation/view/best_seller_view.dart';
import 'package:flower_app/features/occasions/presentation/occasions_view_model/occasions_view_model.dart';
import 'package:flower_app/features/occasions/presentation/pages/occasions_view.dart';
import 'package:flower_app/features/splash/presentation/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flower_app/features/product_details/presentation/pages/product_details_view.dart';
import 'package:flower_app/features/product_details/presentation/view_model/product_details_cubit.dart';
import '../../features/auth/forget-password/presentation/flow/forget_password_routes.dart';
import '../../features/auth/login/presentation/screens/login_screen.dart';
import '../../features/auth/signup/presentation/pages/signup_view.dart';
import '../../features/edit_profile/presentation/screens/edit_profile.dart';

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
        case AppRoutesName.editProfile:
        return MaterialPageRoute(builder: (_) =>  EditProfile());
      case AppRoutesName.occasions:
        final occasionId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<OccasionsViewModel>(),
            child: OccasionsView(initialOccasionId: occasionId),
          ),
        );

      case AppRoutesName.productDetails:
        final productId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ProductDetailsCubit>(),
            child: Builder(
              builder: (context) => ProductDetailsView(productId: productId),
            ),
          ),
        );
      case AppRoutesName.bestSeller:
        return MaterialPageRoute(builder: (_) =>const BestSellerView());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text(AppStrings.routeNotFound)),
          ),
        );
    }
  }
}
