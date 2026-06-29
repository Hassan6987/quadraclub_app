import '/app_exports.dart';

class ParticipantsRow extends StatelessWidget {
  final ClassModel classModel;

  const ParticipantsRow({super.key, required this.classModel});

  @override
  Widget build(BuildContext context) {
    final status = classModel.status;
    final displayParticipants = classModel.participants.take(3).toList();
    final extra = classModel.filledSlots - displayParticipants.length;

    return Row(
      children: [
        SizedBox(
          height: 32,
          width: (displayParticipants.length * 20.0) + (extra > 0 ? 28 : 0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (int i = 0; i < displayParticipants.length; i++)
                Positioned(
                  left: i * 20.0,
                  child: AppCachedImage(
                    borderRadius: BorderRadius.circular(200),
                    height: 32,
                    width: 32,
                    imageUrl: kTennisPlayer,
                    border: Border.all(color: kWhiteColor, width: 2),
                  ),
                ),
              if (extra > 0)
                Positioned(
                  left: displayParticipants.length * 20.0,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: kGreyColor,
                    child: Text(
                      '+$extra',
                      style: AppStyles.w500f12inter.copyWith(
                        color: kDarkTextColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        14.widthBox,
        Text(
          '${classModel.filledSlots}/${classModel.totalSlots}',
          style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
        ),
        const Spacer(),
        _StatusBadge(status: status, slotsLeft: classModel.slotsLeft),
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
