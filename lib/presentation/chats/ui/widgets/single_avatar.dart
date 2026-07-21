import '/app_exports.dart';

class SmallAvatar extends StatelessWidget {
  final double size;
  final String url;

  const SmallAvatar({super.key, required this.size, required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: kWhiteColor, width: 2),
      ),
      child: AppCachedImage(
        height: size,
        width: size,
        imageUrl: url,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}
