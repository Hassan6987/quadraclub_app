import '../../../../app_exports.dart';

class SportBadge extends StatelessWidget {
  final SportType sport;

  const SportBadge({super.key, required this.sport});

  Color get _color {
    switch (sport) {
      case SportType.tennis:
        return kBlueF1;
      case SportType.pickleball:
        return kDarkGreenColor;
      case SportType.beachTennis:
        return kOrangeColor;
      case SportType.pedal:
        return kRedColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _color),
      ),
      child: Text(
        sport.label,
        style: AppStyles.w500f10inter.copyWith(color: _color),
      ),
    );
  }
}
