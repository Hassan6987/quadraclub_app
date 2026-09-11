import '../../../../app_exports.dart';
import '../../data/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final bool highlighted = notification.isUnread;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: highlighted
                ? kPrimaryColor.withValues(alpha: 0.30)
                : kWhiteColor,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: AppStyles.w500f14inter.copyWith(
                        color: kDarkTextColor,
                      ),
                    ),
                    2.heightBox,
                    Text(
                      notification.message,
                      style: AppStyles.w500f12inter.copyWith(color: kTextColor),
                    ),
                    2.heightBox,
                    Text(
                      notification.locationAndTime,
                      style: AppStyles.w500f12inter.copyWith(color: kTextColor),
                    ),
                  ],
                ),
              ),

              12.widthBox,
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    notification.timeAgo,
                    style: AppStyles.w400f12inter.copyWith(color: kTextColor),
                  ),
                  if (highlighted) ...[
                    20.heightBox,
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: kOrangeColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ).withPaddingSymmetric(24, 16),
        ),
        Divider(color: kBorderColor, height: 1, thickness: 1),
      ],
    );
  }
}
