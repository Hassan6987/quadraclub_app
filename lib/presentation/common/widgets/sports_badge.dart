import '../../../app_exports.dart';

class SportBadge extends StatelessWidget {
  final SportType sport;

  const SportBadge({super.key, required this.sport});

  Color get _color {
    switch (sport) {
      case SportType.tennis:
        return kOrangeColor;
      case SportType.pickleball:
        return kDarkGreenColor;
      case SportType.beachTennis:
        return kDarkGreenColor;
      case SportType.pedal:
        return kOrangeColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _color, width: 0.5),
      ),
      child: Text(
        sport.label,
        style: AppStyles.w500f10inter.copyWith(color: _color),
      ),
    );
  }
}
