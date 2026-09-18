import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';

import '/app_exports.dart';

class ClassCard extends StatelessWidget {
  final Class classModel;
  final VoidCallback onTap;

  const ClassCard({super.key, required this.classModel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final isFull = classModel.isFull ?? true;

    final format = classModel.format?.trim().toLowerCase();

    final formatLabel = format == ClassFormat.group.name.toLowerCase()
        ? l10n.group
        : l10n.individual;

    return GestureDetector(
      onTap: isFull ? null : onTap,
      child: Opacity(
        opacity: isFull ? 0.3 : 1,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenHeight(12),
          ),
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: kWhiteFo),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SportBadge(
                    sport: SportTypeExtension.fromString(
                      classModel.sportName ?? '',
                    ),
                  ),

                  4.widthBox,

                  CommonBadge(
                    label: l10n.categoryWithLevel(classModel.level ?? ''),
                  ),

                  4.widthBox,

                  CommonBadge(label: formatLabel),

                  const Spacer(),

                  Text(
                    '\$${classModel.price?.toStringAsFixed(0)}',
                    style: AppStyles.w600f14inter.copyWith(color: kBlueF1),
                  ),
                ],
              ),

              8.heightBox,

              Text(
                classModel.className,
                style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
              ),

              4.heightBox,

              Text(
                '${classModel.startTime}-${classModel.endTime}  •  '
                '${classModel.locationName}  •  '
                '${classModel.distanceKm} km',
                style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
              ),

              8.heightBox,

              Row(
                children: [
                  AppCachedImage(
                    borderRadius: BorderRadius.circular(100),
                    height: 36,
                    width: 36,
                    imageUrl: classModel.coachPhoto ?? '',
                  ),

                  10.widthBox,

                  Text(
                    '${l10n.coach} ',
                    style: AppStyles.w400f14inter.copyWith(
                      color: kGreyTextColor,
                    ),
                  ),

                  Text(
                    classModel.coachName,
                    style: AppStyles.w500f14inter.copyWith(
                      color: kDarkTextColor,
                    ),
                  ),
                ],
              ),

              Divider(color: kBorderColor).withPaddingSymmetric(0, 8),

              ParticipantsRow(classModel: classModel),
            ],
          ).withPaddingAll(12),
        ),
      ),
    );
  }
}
