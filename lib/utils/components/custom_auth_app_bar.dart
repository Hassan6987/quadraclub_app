import '/app_exports.dart';

class CustomAuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackIcon;
  final bool centerTile;
  final String? title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final double? height;
  final bool showActions;
  final Color? backgroundColor;

  const CustomAuthAppBar({
    super.key,
    this.showBackIcon = false,
    this.centerTile = true,
    this.title,
    this.height,
    this.showActions = true,
    this.titleStyle,
    this.backgroundColor = kWhiteColor,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackIcon
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: kDarkTextColor,
                    ),
                  ).paddingOnly(left: 16),
                ),
                Text(
                  'Back',
                  style:
                      titleStyle ??
                      AppStyles.w500f8inter.copyWith(
                        color: kDarkTextColor,
                        fontSize: 16,
                      ),
                ),
              ],
            )
          : null,
      leadingWidth: showBackIcon ? 100 : null,
      backgroundColor: backgroundColor,
      centerTitle: centerTile,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 5, color: kBorderColor)),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight((getProportionateScreenHeight(height ?? 58)) + 1);
}
