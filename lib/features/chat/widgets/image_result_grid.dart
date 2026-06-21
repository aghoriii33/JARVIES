import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/shimmer_loader.dart';

class ImageResultGrid extends StatelessWidget {
  final List<String> imageUrls;

  const ImageResultGrid({
    super.key,
    required this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) return const SizedBox.shrink();

    // Staggered grid for 3 images
    if (imageUrls.length >= 3) {
      return SizedBox(
        height: 180,
        child: Row(
          children: [
            // Left main image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: _buildImage(imageUrls[0]),
              ),
            ),
            const SizedBox(width: 6),
            // Right stacked images
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(16),
                      ),
                      child: _buildImage(imageUrls[1]),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(16),
                      ),
                      child: _buildImage(imageUrls[2]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Default to side by side or single image
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 150,
              child: _buildImage(imageUrls[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImage(String url) {
    // If it's a mock local asset vs network URL
    final isNetwork = url.startsWith('http://') || url.startsWith('https://');

    if (isNetwork) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder: (context, _) => const ShimmerLoader.rectangular(height: double.infinity),
        errorWidget: (context, _, __) => Container(
          color: AppColors.surface2,
          child: const Center(
            child: Icon(Icons.broken_image_rounded, color: AppColors.textDisabled, size: 24),
          ),
        ),
      );
    } else {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, _, __) => Container(
          color: AppColors.surface2,
          child: const Center(
            child: Icon(Icons.image_outlined, color: AppColors.textDisabled, size: 24),
          ),
        ),
      );
    }
  }
}
