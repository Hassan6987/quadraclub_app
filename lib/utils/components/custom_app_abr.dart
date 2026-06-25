import '/app_exports.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackIcon;
  final bool centerTile;
  final String? title;
  final double? height;

  const CustomAppBar({
    super.key,
    this.showBackIcon = false,
    this.centerTile = true,
    this.title,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actionsPadding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(16),
      ),
      shape: RoundedRectangleBorder(side: BorderSide(color: kCardColor)),
      title: title != null
          ? Text(
              title!,
              style: AppStyles.w600f24inter.copyWith(
                color: kDarkTextColor,
                fontSize: 22,
              ),
            )
          : null,
      actions: [
        buildContainer(Assets.svg.notification.path),
        8.widthBox,
        buildContainer(Assets.svg.chatIcon.path),
      ],
    );
  }

  Container buildContainer(String icon) {
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        shape: BoxShape.circle,
        border: Border.all(color: kBorderColor),
      ),
      child: SvgPicture.asset(icon).withPaddingAll(8),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(getProportionateScreenHeight(height ?? 68));
}
