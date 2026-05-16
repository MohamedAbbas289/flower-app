import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../config/di/di.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/images_paths.dart';
import '../view_model/cubit/home_view_model.dart';
import '../view_model/states/home_events.dart';
import '../view_model/states/home_state.dart';
import '../widgets/best_seller_item.dart';
import '../widgets/category_item.dart';
import '../widgets/occasion_item.dart';
import '../widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeViewModel homeViewModel = getIt<HomeViewModel>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => homeViewModel..doEvent(GetAllDataEvent()),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 100,
                  child: SvgPicture.asset(
                    Assets.assetsImagesFlowerIcon,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: AppStrings.search,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Icon(Icons.search),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(Assets.assetsIconsLocationOn),
                    const Text(AppStrings.location),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.pink,
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                SectionHeader(
                  title: AppStrings.categoryView,
                  actionText: AppStrings.viewAll,
                  onTap: () {},
                ),

                BlocBuilder<HomeViewModel, HomeState>(
                  builder: (context, state) {
                    if (state.categoriesError.isNotEmpty) {
                      return Center(child: Text(state.categoriesError));
                    }
                    if (state.categories.isNotEmpty &&
                        !state.categoriesLoading) {
                      return SizedBox(
                        height: size.height * 0.10,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.categories.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            return CategoryItem(
                              onTap: () {},
                              image: state.categories[index].image,
                              name: state.categories[index].name,
                            );
                          },
                        ),
                      );
                    }
                    if (state.categoriesLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.pink),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  buildWhen: (previous, current) {
                    return previous.categories != current.categories;
                  },
                ),

                const SizedBox(height: 15),

                SectionHeader(
                  title: AppStrings.bestSellers,
                  actionText: AppStrings.viewAll,
                  onTap: () {},
                ),

                BlocBuilder<HomeViewModel, HomeState>(
                  builder: (context, state) {
                    if (state.bestSellersError.isNotEmpty) {
                      return Center(child: Text(state.bestSellersError));
                    }
                    if (state.bestSellers.isNotEmpty &&
                        !state.bestSellersLoading) {
                      return SizedBox(
                        height: size.height * 0.23,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.bestSellers.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            return BestSellerItem(
                              onTap: () {},
                              name: state.bestSellers[index].slug!,
                              image: state.bestSellers[index].imgCover!,
                              price: state.bestSellers[index].price!,
                            );
                          },
                        ),
                      );
                    }
                    if (state.bestSellersLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.pink),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  buildWhen: (previous, current) {
                    return previous.bestSellers != current.bestSellers;
                  },
                ),

                const SizedBox(height: 15),

                SectionHeader(
                  title: AppStrings.occasion,
                  actionText: AppStrings.viewAll,
                  onTap: () {},
                ),
                BlocBuilder<HomeViewModel, HomeState>(
                  builder: (context, state) {
                    if (state.occasionsError.isNotEmpty) {
                      return Center(child: Text(state.occasionsError));
                    }
                    if (state.occasions.isNotEmpty && !state.occasionsLoading) {
                      return SizedBox(
                        height: size.height * 0.22,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.occasions.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            return OccasionItem(
                              onTap: () {},
                              name: state.occasions[index].name!,
                              image: state.occasions[index].image!,
                            );
                          },
                        ),
                      );
                    }
                    if (state.occasionsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.pink),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  buildWhen: (previous, current) {
                    return previous.occasions != current.occasions;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
