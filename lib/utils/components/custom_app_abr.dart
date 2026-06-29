import '/app_exports.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackIcon;
  final bool centerTile;
  final String? title;
  final TextStyle? titleStyle;
  final double? height;
  final bool showActions;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    this.showBackIcon = false,
    this.centerTile = true,
    this.title,
    this.height,
    this.showActions = true,
    this.titleStyle,
    this.backgroundColor=kWhiteColor
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackIcon
          ? InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  border: Border.all(color: kBorderColor),
                ),
                child: Icon(Icons.arrow_back, size: 24, color: kDarkTextColor),
              ).paddingOnly(left: 16),
            )
          : null,
      backgroundColor: backgroundColor,
      centerTitle: centerTile,
      actionsPadding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(16),
      ),
      shape: RoundedRectangleBorder(side: BorderSide(color: kCardColor)),
      title: title != null
          ? Text(
              title!,
              style:
                  titleStyle ??
                  AppStyles.w600f24inter.copyWith(
                    color: kDarkTextColor,
                    fontSize: 22,
                  ),
            )
          : null,
      actions: showActions
          ? [
              InkWell(
                onTap: () => _onTapAction(context, RouteName.notifications),
                child: buildContainer(Assets.svg.notification.path),
              ),
              8.widthBox,
              InkWell(child: buildContainer(Assets.svg.chatIcon.path)),
            ]
          : null,
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

  void _onTapAction(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(getProportionateScreenHeight(height ?? 68));
}
