import '/app_exports.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackIcon;
  final bool centerTile;
  final String? title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final double? height;
  final bool showActions;
  final Color? backgroundColor;
  final bool showBorder;
  final bool showThreeDotActions;
  final VoidCallback? onThreeDotTap;

  const CustomAppBar({
    super.key,
    this.showBackIcon = false,
    this.centerTile = true,
    this.title,
    this.height,
    this.showActions = true,
    this.titleStyle,
    this.backgroundColor = kWhiteColor,
    this.subtitle,
    this.showBorder = false,
    this.showThreeDotActions = false,
    this.onThreeDotTap,
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
      shape: RoundedRectangleBorder(
        side: BorderSide(color: showBorder ? kCardColor : Colors.transparent),
      ),
      title: Column(
        children: [
          if (title != null)
            Text(
              title!,
              style:
                  titleStyle ??
                  AppStyles.w600f24inter.copyWith(
                    color: kDarkTextColor,
                    fontSize: 22,
                  ),
            ),

          if (subtitle != null) ...[
            2.heightBox,
            Text(
              subtitle!,
              style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
            ),
          ],
        ],
      ),
      actions: showActions
          ? [
              InkWell(
                onTap: () => _onTapAction(context, RouteName.notifications),
                child: buildContainer(Assets.svg.notification.path),
              ),
              8.widthBox,
              InkWell(
                onTap: () => _onTapAction(context, RouteName.myChats),
                child: buildContainer(Assets.svg.chatIcon.path),
              ),
            ]
          : showThreeDotActions
          ? [
              InkWell(
                onTap:
                    onThreeDotTap ??
                    () => _onTapAction(context, RouteName.notifications),
                child: threeDotActions(),
              ),
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

  Widget threeDotActions() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,

        border: Border.all(color: kBorderColor),
      ),
      child: Icon(Icons.more_horiz, size: 24, color: kDarkTextColor),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(getProportionateScreenHeight(height ?? 68));
}
