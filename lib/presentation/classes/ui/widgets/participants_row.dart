import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';

import '/app_exports.dart';

class ParticipantsRow extends StatelessWidget {
  final Class classModel;

  const ParticipantsRow({super.key, required this.classModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CommonAvatarStackRow(
          imageUrls: classModel.participants
              .map((c) =>
          c.profilePhoto ??
              '') // swap for real per-participant url when available
              .toList(),
          maxVisible: 3,
          avatarSize: 32,
          totalCount: classModel.currentParticipants,
        ),
        14.widthBox,
        Text(
          '${classModel.currentParticipants}/${classModel.maxStudents}',
          style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
        ),
        const Spacer(),
        _StatusBadge(status: ClassStatusExtension.fromString(
            classModel.statusLabel ?? ''),
            slotsLeft: classModel.slotsLeft ?? 0),
      ],
    );
  }
}
class _StatusBadge extends StatelessWidget {
  final ClassStatus status;
  final int slotsLeft;

  const _StatusBadge({required this.status, required this.slotsLeft});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case ClassStatus.full:
        return Text(
          'Full',
          style: AppStyles.w500f12inter.copyWith(color: kBlueColor),
        );
      case ClassStatus.slotsLeft:
        return Text(
          '$slotsLeft Slots Left',
          style: AppStyles.w500f12inter.copyWith(color: kBlueColor),
        );
      case ClassStatus.available:
        return Text(
          'Available',
          style: AppStyles.w500f12inter.copyWith(color: kBlueColor),
        );
    }
  }
}