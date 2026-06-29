import 'package:dotted_border/dotted_border.dart';

import '../../../../app_exports.dart';

class ParticipantsCard extends StatelessWidget {
  const ParticipantsCard({
    super.key,
    required this.classModel,
  });

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
                style: AppStyles.w500f14inter.copyWith(
                  color: kDarkTextColor,
                ),
              ),
              Text(
                '${classModel.filledSlots}/${classModel.totalSlots}',
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
            children: List.generate(classModel.totalSlots, (i) {
              final isFilled = i < classModel.filledSlots;

              return isFilled
                  ? AppCachedImage(
                height: 40,
                width: 40,
                borderRadius: BorderRadius.circular(1000),
              )
                  : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000),
                  border: Border.all(
                    color: kWhiteColor,
                    width: 3,
                  ),
                ),
                child: DottedBorder(
                  options: CircularDottedBorderOptions(
                    color: kDottedBorderColor,
                    dashPattern: [7.5, 5],
                  ),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kWhiteF9,
                    ),
                    child: isFilled
                        ? const CircleAvatar(
                      backgroundColor: Color(0xFFE0E0E0),
                      child: Icon(
                        Icons.person,
                        size: 22,
                        color: Colors.white,
                      ),
                    )
                        : const Icon(
                      Icons.add,
                      size: 20,
                      color: Color(0xFFCCCCCC),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ).withPaddingSymmetric(20, 16),
    );
  }
}
