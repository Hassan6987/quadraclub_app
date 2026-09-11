import '/app_exports.dart';

class StatisticsCard extends StatelessWidget {
  final PlayerStats stats;
  final StatFilter selected;
  final ValueChanged<StatFilter> onFilterChanged;

  const StatisticsCard({
    super.key,
    required this.stats,
    required this.selected,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Statistics',
                style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
              ),
              Row(
                children: StatFilter.values.map((f) {
                  final isSelected = f == selected;
                  return GestureDetector(
                    onTap: () => onFilterChanged(f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(left: 4),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? kPrimaryColor
                            : kPrimaryColor.withValues(alpha: 0.20),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        f.name[0].toUpperCase() + f.name.substring(1),
                        style: AppStyles.w500f12inter.copyWith(
                          color: kDarkTextColor,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          16.heightBox,
          IntrinsicHeight(
            child: Row(
              spacing: getProportionateScreenWidth(8),
              children: [
                _StatItem(
                  icon: Assets.svg.personsIcon.path,
                  value: '${stats.matches}',
                  label: 'Matches',
                  color: kBlackColor,
                ),
                _StatItem(
                  icon: Assets.svg.trophyIcon.path,
                  value: '${stats.victories}',
                  label: 'Victories',
                  color: kLightGreenColor,
                ),
                _StatItem(
                  icon: Assets.svg.redCross.path,
                  value: '${stats.defeats}',
                  label: 'Defeats',
                  color: kRedColor,
                ),
                _StatItem(
                  icon: Assets.svg.timerIcon.path,
                  value: '${stats.hours} h',
                  label: 'Hours',
                  color: kBlackColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kBorderColor),
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            Text(
              value,
              style: AppStyles.w600f16inter.copyWith(color: color),
            ).withPaddingSymmetric(0, 2),

            Text(
              label,
              textAlign: TextAlign.center,
              style: AppStyles.w400f12inter.copyWith(
                color: kDarkTextColor.withValues(alpha: 0.50),
              ),
            ),
          ],
        ).withPaddingAll(8),
      ),
    );
  }
}
