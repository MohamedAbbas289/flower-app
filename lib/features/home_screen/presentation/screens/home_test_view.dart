import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/images_paths.dart';
import '../widgets/best_seller_item.dart';
import '../widgets/category_item.dart';
import '../widgets/occasion_item.dart';
import '../widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
   final size = MediaQuery.of(context).size;
    return Scaffold(
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
                      hintText: 'Search',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: const Icon(Icons.search),
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
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10
        ),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SvgPicture.asset(Assets.assetsIconsLocationOn),
                  Text(AppStrings.location,),
                  Icon(Icons.keyboard_arrow_down,
                  color: AppColors.pink,)
                ],
              ),
              SectionHeader(
                title: AppStrings.categoryView,
                actionText: AppStrings.viewAll,
                onTap: () {},
              ),
              SizedBox(
                height: size.height * 0.10,
                child: ListView.separated(
                  itemCount: 5,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) => CategoryItem(
                    onTap: (){},
                    image: Icons.favorite,
                    name: 'Flowers',
          
                  ),
                ),
              ),
              SectionHeader(
                title: AppStrings.bestSellers,
                actionText: AppStrings.viewAll,
                onTap: () {},
              ),
              SizedBox(
                height: size.height * 0.23,
                child: ListView.separated(
                  itemCount: 5,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) =>  BestSellerItem(
                      onTap: (){},
                      name: 'Flowers',
                      image: AssetImage('assets/images/weding.png')
                      ,price: '100'
          
                  ),
                ),
              ),
          
              SectionHeader(
                title: AppStrings.occasion,
                actionText: AppStrings.viewAll,
                onTap: () {},
              ),
              SizedBox(
                height: size.height * 0.22,
          
                child: ListView.separated(
                  itemCount: 5,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) =>  OccasionItem(
                    onTap: (){},
                    name: 'Flowers',
                    image: AssetImage('assets/images/weding.png')
          
                  ),
                ),
              ),
          
          
            ],
          ),
        ),
      ),
    );
  }
}