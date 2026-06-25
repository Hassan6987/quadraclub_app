import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '/app_exports.dart';

class AppCachedImage extends StatelessWidget {
  final String? imageUrl;
  final File? localFile;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppCachedImage({
    super.key,
    this.imageUrl,
    this.localFile,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final Widget imageWidget = localFile != null
        ? Image.file(
      localFile!,
      height: height,
      width: width,
      fit: fit,
    )
        : CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      height: height,
      width: width,
      fit: fit,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: height,
          width: width ?? double.infinity,
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: height,
        width: width,
        color: kGreyColor,

      ),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }
}