import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';
import 'package:quadraclub_app/presentation/common/widgets/common_plus_avatar.dart';
import 'package:quadraclub_app/presentation/matches/ui/player_profile_screen.dart';

import '../../../../app_exports.dart';

class ParticipantsCard extends StatelessWidget {
  const ParticipantsCard({super.key, required this.classModel});

  final Class classModel;

  static const int _columns = 4;
  static const double _spacing = 10;

  @override
  Widget build(BuildContext context) {
    final participants = classModel.participants;
    final maxStudents = classModel.maxStudents ?? 0;

    final filledParticipants = participants.take(maxStudents).toList();

    final emptySlots = (maxStudents - filledParticipants.length).clamp(
      0,
      maxStudents,
    );

    return Container(
      decoration: BoxDecoration(
        color: kWhiteF9,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Participants',
                style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
              ),
              Text(
                '${filledParticipants.length}/$maxStudents',
                style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
              ),
            ],
          ),
          18.heightBox,
          LayoutBuilder(
            builder: (context, constraints) {
              // Equal column width so every item lines up in a grid.
              final itemWidth =
                  (constraints.maxWidth - _spacing * (_columns - 1)) /
                      _columns;

              return Wrap(
                spacing: _spacing,
                runSpacing: 16,
                children: [
                  ...filledParticipants.map(
                        (participant) => SizedBox(
                      width: itemWidth,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlayerProfileScreen(
                                playerId: participant.id ?? '',
                              ),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppCachedImage(
                              height: 46,
                              width: 46,
                              borderRadius: BorderRadius.circular(1000),
                              imageUrl: participant.profilePhoto ?? '',
                            ),
                            6.heightBox,
                            Text(
                              participant.fullName ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: AppStyles.w500f12inter.copyWith(
                                color: kDarkTextColor,
                              ),
                            ),
                            // Optional: category line like the mockup
                            Text(
                              participant.level,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.w400f12inter.copyWith(
                                color: kGreyTextColor,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Empty slots, same width so they stay in the grid
                  ...List.generate(
                    emptySlots,
                        (_) => SizedBox(
                      width: itemWidth,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CommonPlusAvatar(),
                          4.heightBox,
                          Text(
                            'Vaga',
                            style: AppStyles.w500f12inter.copyWith(
                              color: kGreyTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ).withPaddingSymmetric(20, 16),
    );
  }
}