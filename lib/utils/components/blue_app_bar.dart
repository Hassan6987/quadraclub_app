import 'package:quadraclub_app/app_exports.dart';

class BlueAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackArrow;
  final String? title;
  final Widget? titleWidget;
  final Widget? actionButton;
  final VoidCallback? onBackPressed;
  final Color contentColor;
  final double height;

  const BlueAppBar({
    super.key,
    this.showBackArrow = false,
    this.title,
    this.titleWidget,
    this.actionButton,
    this.onBackPressed,
    this.contentColor = Colors.white,
    this.height = 120.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        // For Android
        statusBarBrightness: Brightness.dark,
        // For iOS
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left side - Back arrow or empty space
                if (showBackArrow)
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: contentColor,
                      size: 24,
                    ),
                    onPressed:
                        onBackPressed ?? () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                else
                  const SizedBox(width: 20),

                // Center - Title or custom widget
                Expanded(
                  child:
                      titleWidget ??
                      (title != null
                          ? Center(
                              child: Text(title!, style: AppStyles.titleMedium),
                            )
                          : const SizedBox.shrink()),
                ),

                // Right side - Action button or empty space
                if (actionButton != null)
                  actionButton!
                else
                  const SizedBox(width: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
