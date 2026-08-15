import '../../../app_exports.dart';

class EventCard extends StatelessWidget {
  final String eventName;
  final String date;
  final String location;
  final String score;

  const EventCard({
    super.key,
    required this.eventName,
    required this.date,
    required this.location,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: kBlackColor.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  eventName,
                  style: AppStyles.subtitleMedium.copyWith(color: kBlackColor),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Score: $score',
                  style: AppStyles.bodyRegular.copyWith(color: kPrimaryColor),
                ),
              ),
            ],
          ),
          8.heightBox,
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 14, color: kTextColor),
              8.widthBox,
              Text(
                date,
                style: AppStyles.bodyRegular.copyWith(color: kTextColor),
              ),
            ],
          ),
          4.heightBox,
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: kTextColor),
              8.widthBox,
              Text(
                location,
                style: AppStyles.bodyRegular.copyWith(color: kTextColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
