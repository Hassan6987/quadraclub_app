// lib/screens/vendor/profile/widgets/profile_menu_list_item.dart

import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/utils/const/dimensions_resource.dart';

import '../../data/profile_menu_model.dart';

class ProfileMenuListItem extends StatelessWidget {
  final ProfileMenuItem item;

  const ProfileMenuListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Dim.D_16, vertical: Dim.D_12),
        margin: EdgeInsets.only(bottom: Dim.PADDING_SIZE_DEFAULT),
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              item.icon,
              colorFilter: ColorFilter.mode(item.color, BlendMode.srcIn),
              width: 24,
              height: 24,
            ),
            8.widthBox,
            Expanded(
              child: Text(
                item.title,
                style: AppStyles.subtitleMedium.copyWith(color: item.color),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: item.color, size: 16),
          ],
        ),
      ),
    );
  }
}
