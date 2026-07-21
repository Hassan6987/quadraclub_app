import '../../../../app_exports.dart';

class ActionsBottomSheet extends StatelessWidget {
  const ActionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _header(
            onTap: () {
              Navigator.pop(context);
            },
          ),
          CommonDivider(),
          _actionItem(
            icon: Icons.edit_outlined,
            title: 'Edit Details',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _actionItem(
            icon: Icons.delete_outline,
            title: 'Delete Match',
            color: kRed5B,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          24.heightBox,
        ],
      ),
    );
  }

  Widget _header({VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      child: Row(
        children: [
          Text(
            'Actions',
            style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onTap,
            child: const Icon(Icons.close, color: kDarkTextColor, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _actionItem({
    required IconData icon,
    Color color = kDarkTextColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            16.widthBox,
            Text(title, style: AppStyles.w500f14inter.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
