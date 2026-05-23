// widgets/athlete_card_widget.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/team_roster/bloc/team_roster_bloc.dart';
import 'package:quadraclub_app/presentation/team_roster/data/team_roster_model.dart';
import 'package:quadraclub_app/utils/components/alert_dialogue.dart';
import 'package:quadraclub_app/utils/const/dimensions_resource.dart';
import 'package:quadraclub_app/utils/extensions/padding_extension.dart';

class AthleteCardWidget extends StatelessWidget {
  final TeamRoster athlete;
  final VoidCallback? onTap;

  const AthleteCardWidget({super.key, required this.athlete, this.onTap});

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
            // ── Avatar ──────────────────────────────────────────────
            athlete.athleteProfile?.image != null &&
                    athlete.athleteProfile!.image!.isNotEmpty
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: athlete.athleteProfile!.image!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => CircleAvatar(
                        radius: 30,
                        backgroundColor: _getColorFromName(
                          athlete.athleteProfile?.fullName ?? "Unknown",
                        ),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        radius: 30,
                        backgroundColor: _getColorFromName(
                          athlete.athleteProfile?.fullName ?? "Unknown",
                        ),
                        child: Text(
                          _getInitials(
                            athlete.athleteProfile?.fullName ?? "Unknown",
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
                      athlete.athleteProfile?.fullName ?? "Unknown",
                    ),
                    child: Text(
                      _getInitials(
                        athlete.athleteProfile?.fullName ?? "Unknown",
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

            8.widthBox,

            // ── Name + Position ──────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    athlete.athleteProfile?.fullName ?? "Unknown",
                    style: AppStyles.subtitleMedium.copyWith(
                      color: kBlackColor,
                    ),
                  ),
                  4.heightBox,
                  Text(
                    athlete.athleteProfile?.position ?? "Unknown",
                    style: AppStyles.bodyRegular.copyWith(color: kBlackColor),
                  ),
                ],
              ),
            ),

            // ── Graduation year + Remove button ──────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${athlete.athleteProfile?.graduationYear}",
                  style: AppStyles.bodyRegular.copyWith(color: kPrimaryColor),
                ),
                8.heightBox,
                _RemoveButton(
                  onTap: () => _showRemoveAthleteDialog(context, athlete.id!),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveAthleteDialog(BuildContext context, int athleteId) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => CustomAlertDialog(
          title: 'Remove Athlete',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Are you sure you want to remove athlete from roster?',
                style: AppStyles.subtitleMedium.copyWith(color: kBlackColor),
                textAlign: TextAlign.center,
              ),
            ],
          ).withPaddingSymmetric(16, 0),
          onButtonTap: () {
            context.read<TeamRosterBloc>().add(
              RemovePlayerFromRoster(playerId: athleteId),
            );
            Navigator.pop(context);
          },
          leftButtonText: 'No',
          rightButtonText: 'Yes',
        ),
      ),
    );
  }

  String _getInitials(String name) {
    List<String> names = name.split(' ');
    String initials = '';
    if (names.isNotEmpty) {
      initials += names[0][0];
      if (names.length > 1) initials += names[1][0];
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

// ── Standalone remove button widget ─────────────────────────────────────────

class _RemoveButton extends StatelessWidget {
  final VoidCallback onTap;

  const _RemoveButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEDED), // soft red tint
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFEF5350).withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.remove_circle_outline_rounded,
              color: Color(0xFFEF5350),
              size: 13,
            ),
            const SizedBox(width: 4),
            Text(
              "Remove",
              style: AppStyles.bodyRegular.copyWith(
                color: const Color(0xFFEF5350),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
