import 'package:intl/intl.dart';
import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';
import 'package:quadraclub_app/utils/helper/date_formatter.dart';

import '/app_exports.dart';

class InfoCard extends StatelessWidget {
  final Class classModel;
  final double distanceKm;

  const InfoCard({
    super.key,
    required this.classModel,
    required this.distanceKm,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateStr = DateFormat(
      'EEE, MMM d',
      l10n.localeName,
    ).format(classModel.date!);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kWhiteF9,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                classModel.className,
                style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
              ),
              Text(
                '\$${classModel.price?.toStringAsFixed(0)}',
                style: AppStyles.w600f16inter.copyWith(color: kBlueColor),
              ),
            ],
          ),

          Row(
            children: [
              SportBadge(
                sport: SportTypeExtension.fromString(
                  classModel.sportName ?? '',
                ),
              ),
              4.widthBox,
              CommonBadge(label: classModel.statusLabel ?? ''),
            ],
          ).withPaddingSymmetric(0, 8),

          Row(
            spacing: getProportionateScreenWidth(30),
            children: [
              _InfoRow(icon: Assets.svg.calendarBlank.path, text: dateStr),
              _InfoRow(
                icon: Assets.svg.timerIcon.path,
                text: '${classModel.startTime}-${classModel.endTime}',
              ),
            ],
          ),
          10.heightBox,
          _InfoRow(
            icon: Assets.svg.locationIcon.path,
            text:
                '${classModel.locationName} · ${formatDistanceKm(distanceKm)}',
          ),
          8.heightBox,
          _InfoRow(
            icon: Assets.svg.locationIcon.path,
            text: '${classModel.court?.courtName}',
          ),
          8.heightBox,
          Row(
            children: [
              AppCachedImage(
                borderRadius: BorderRadius.circular(100),
                height: 36,
                width: 36,
                imageUrl: classModel.coachPhoto,
              ),
              10.widthBox,
              Text(
                '${l10n.coach} ',
                style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
              ),
              Text(
                classModel.coachName ?? '',
                style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
              ),
              Spacer(),
              _InfoRow(
                icon: Assets.svg.starYellow.path,
                iconColor: kOrangeColor,
                text: "Cat 6",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String icon;
  final String text;
  final Color? iconColor;

  const _InfoRow({required this.icon, required this.text, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          height: 16,
          width: 16,
          colorFilter: ColorFilter.mode(
            iconColor ?? kGreyTextColor,
            BlendMode.srcIn,
          ),
        ),
        6.widthBox,
        Text(
          text,
          style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
        ),
      ],
    );
  }
}
