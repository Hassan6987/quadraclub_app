import 'package:quadraclub_app/presentation/common/widgets/common_plus_avatar.dart';

import '../../../../app_exports.dart';

class ParticipantsCard extends StatelessWidget {
  const ParticipantsCard({super.key, required this.classModel});

  final ClassModel classModel;

  @override
  Widget build(BuildContext context) {
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
                '${classModel.filledSlots}/${classModel.totalSlots}',
                style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
              ),
            ],
          ),
          18.heightBox,
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(classModel.totalSlots, (i) {
              final isFilled = i < classModel.filledSlots;

              return isFilled
                  ? AppCachedImage(
                      height: 40,
                      width: 40,
                      borderRadius: BorderRadius.circular(1000),
                    )
                  : CommonPlusAvatar();
            }),
          ),
        ],
      ).withPaddingSymmetric(20, 16),
    );
  }
}
