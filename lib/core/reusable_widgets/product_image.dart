import 'package:cached_network_image/cached_network_image.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/utils/app_responsive.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.imageUrl,
    this.heroTag,
    this.radius = 0,
    required this.size,
    required this.devicePixelRatio,
  });

  final String imageUrl;
  final String? heroTag;
  final Size size;
  final double devicePixelRatio;
  final double radius;
  @override
  Widget build(BuildContext context) {
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 300),
        memCacheWidth: AppResponsive.cardCacheWidth(size, devicePixelRatio),
        placeholder: (context, url) => const _ImagePlaceholder(),
        errorWidget: (context, url, error) => _ImageError(imageUrl: imageUrl),
      ),
    );

    if (heroTag == null) return image;

    return Hero(tag: heroTag!, child: image);
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.placeHolder.withAlpha(77),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

class _ImageError extends StatefulWidget {
  const _ImageError({required this.imageUrl});
  final String imageUrl;

  @override
  State<_ImageError> createState() => _ImageErrorState();
}

class _ImageErrorState extends State<_ImageError> {
  Future<void> _retry() async {
    await CachedNetworkImage.evictFromCache(widget.imageUrl);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.placeHolder.withAlpha(51),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.image_not_supported_outlined,
            size: 28,
            color: AppColors.gray,
          ),
          const SizedBox(height: 4),
          const Text(
            AppStrings.imageNotAvailable,
            style: TextStyle(fontSize: 10, color: AppColors.gray),
          ),
          const SizedBox(height: 6),
          IconButton(
            onPressed: _retry,
            icon: const Icon(Icons.refresh, color: AppColors.gray),
          ),
        ],
      ),
    );
  }
}
