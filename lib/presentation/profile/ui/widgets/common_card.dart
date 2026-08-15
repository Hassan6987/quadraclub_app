import '../../../../app_exports.dart';

class CommonCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets? padding;

  const CommonCard({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.padding ,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:padding?? EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(16),
        vertical: getProportionateScreenHeight(16),
      ),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: kDividerColor),
      ),
      child: child,
    );
  }
}
