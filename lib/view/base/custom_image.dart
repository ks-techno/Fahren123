import 'package:Fahren123/util/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double ?height;
  final double ?width;
  final BoxFit fit;
  CustomImage({required this.image, this.height, this.width, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return OptimizedCacheImage(
      imageUrl: image, height: height, width: width, fit: fit,
      placeholder: (context, url) => Image.asset(Images.placeholder, height: height, width: width, fit: fit),
      errorWidget: (context, url, error) => Image.asset(Images.placeholder, height: height, width: width, fit: fit),
    );
  }
}
