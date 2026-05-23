import '/app_exports.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackIcon;
  final bool centerTile;
  final String? title;
  final double? height;

  const CustomAppBar({
    super.key,
    this.showBackIcon = true,
    this.centerTile = true,
    this.title,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title ?? 'Custom AppBar',
        style: AppStyles.w600f24inter.copyWith(
          fontSize: 16,
          color: kBlackColor,
        ),
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      leading: showBackIcon
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_new, size: 24),
              style: IconButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : null,
      toolbarHeight: getProportionateScreenHeight(173),
      centerTitle: centerTile,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(getProportionateScreenHeight(height ?? 80));
}
