// widgets/athlete_card_widget.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/data/athlete_model.dart';
import 'package:quadraclub_app/utils/const/dimensions_resource.dart';

class ScannedAthleteCardWidget extends StatelessWidget {
  final AthleteModel athlete;
  final VoidCallback? onTap;

  const ScannedAthleteCardWidget({
    super.key,
    required this.athlete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Dim.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(Dim.RADIUS_SMALL),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 6,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            athlete.scannedUserProfile?.image != null &&
                    athlete.scannedUserProfile!.image!.isNotEmpty
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: athlete.scannedUserProfile!.image!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => CircleAvatar(
                        radius: 30,
                        backgroundColor: _getColorFromName(
                          athlete.scannedUserProfile?.fullName ?? "Unknown",
                        ),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        radius: 30,
                        backgroundColor: _getColorFromName(
                          athlete.scannedUserProfile?.fullName ?? "Unknown",
                        ),
                        child: Text(
                          _getInitials(
                            athlete.scannedUserProfile?.fullName ?? "Unknown",
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: 30,
                    backgroundColor: _getColorFromName(
                      athlete.scannedUserProfile?.fullName ?? "Unknown",
                    ),
                    child: Text(
                      _getInitials(
                        athlete.scannedUserProfile?.fullName ?? "Unknown",
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
            8.widthBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    athlete.scannedUserProfile?.fullName ?? "Unknown",
                    style: AppStyles.subtitleMedium.copyWith(
                      color: kBlackColor,
                    ),
                  ),
                  4.heightBox,
                  Text(
                    athlete.scannedUserProfile?.position ?? "Unknown",
                    style: AppStyles.bodyRegular.copyWith(color: kBlackColor),
                  ),
                ],
              ),
            ),
            Text(
              "${athlete.scannedUserProfile?.graduationYear}",
              style: AppStyles.bodyRegular.copyWith(color: kPrimaryColor),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    List<String> names = name.split(' ');
    String initials = '';
    if (names.isNotEmpty) {
      initials += names[0][0];
      if (names.length > 1) {
        initials += names[1][0];
      }
    }
    return initials.toUpperCase();
  }

  Color _getColorFromName(String name) {
    int hash = name.hashCode;
    List<Color> colors = [
      const Color(0xFF5B8DEE),
      const Color(0xFF7E57C2),
      const Color(0xFF26A69A),
      const Color(0xFFEF5350),
      const Color(0xFFFF7043),
      const Color(0xFFAB47BC),
    ];
    return colors[hash.abs() % colors.length];
  }
}
