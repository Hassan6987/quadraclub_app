import 'package:intl/intl.dart';
import 'package:quadraclub_app/presentation/chats/ui/widgets/single_avatar.dart';

import '/app_exports.dart';

class MessageTile extends StatelessWidget {
  final ChatMessage message;

  const MessageTile({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('h:mm a').format(message.sentAt);

    if (message.isMe) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'YOU',
              style: AppStyles.w500f10inter.copyWith(color: kTextColor),
            ).paddingOnly(right: 32),
            4.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      message.text,
                      style: AppStyles.w400f14inter.copyWith(
                        color: kDarkTextColor,
                      ),
                    ),
                  ),
                ),
                6.widthBox,
                SmallAvatar(size: 24, url: ''),
              ],
            ),
            6.heightBox,

            Text(
              timeStr,
              style: AppStyles.w500f10inter.copyWith(color: kTextColor),
            ).paddingOnly(right: 32),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.senderName.toUpperCase(),
            style: AppStyles.w500f10inter.copyWith(color: kTextColor),
          ).paddingOnly(left: 32),
          4.heightBox,

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SmallAvatar(size: 24, url: ""),
              6.widthBox,
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    border: Border.all(color: kBorderColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    message.text,
                    style: AppStyles.w400f14inter.copyWith(
                      color: kDarkTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          6.heightBox,

          Text(
            timeStr,
            style: AppStyles.w500f10inter.copyWith(color: kTextColor),
          ).paddingOnly(left: 32),
        ],
      ),
    );
  }
}
