import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';
import 'package:quadraclub_app/presentation/common/widgets/common_plus_avatar.dart';

import '../../../../app_exports.dart';

class ParticipantsCard extends StatelessWidget {
  const ParticipantsCard({
    super.key,
    required this.classModel,
  });

  final Class classModel;

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
                style: AppStyles.w500f14inter.copyWith(
                  color: kDarkTextColor,
                ),
              ),
              Text(
                '${filledParticipants.length}/$maxStudents',
                style: AppStyles.w400f14inter.copyWith(
                  color: kGreyTextColor,
                ),
              ),
            ],
          ),
          18.heightBox,
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              // Participants who have joined
              ...filledParticipants.map(
                    (participant) =>
                    AppCachedImage(
                      height: 40,
                      width: 40,
                      borderRadius: BorderRadius.circular(1000),
                      // Replace this with your actual Participant image field
                      imageUrl: participant.profilePhoto ?? '',
                    ),
              ),

              // Empty participant slots
              ...List.generate(
                emptySlots,
                    (_) => const CommonPlusAvatar(),
              ),
            ],
          ),
        ],
      ).withPaddingSymmetric(20, 16),
    );
  }
}