import '/app_exports.dart';

class ChatListItem extends StatelessWidget {
  final ChatPreview chat;
  final VoidCallback onTap;

  const ChatListItem({super.key, required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasUnread = chat.unreadCount > 0;
    final shortDate = 'Sun, Apr 20. 9:00';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: hasUnread
              ? kPrimaryColor.withValues(alpha: 0.20)
              : kWhiteColor,

          border: Border.all(color: kCardColor),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(16),
          vertical: getProportionateScreenHeight(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (chat.extraParticipantsCount > 0)
              StackedAvatars(
                imgUrls: chat.participants.map((e) => e.avatarUrl).toList(),
              )
            else
              AppCachedImage(
                borderRadius: BorderRadius.circular(200),
                height: 32,
                width: 32,
                imageUrl: '',
              ),

            12.widthBox,

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        chat.venueName,
                        style: AppStyles.w500f14inter.copyWith(
                          color: kTextPrimaryColor,
                        ),
                      ),
                      4.widthBox,
                      ChatTypeTag(type: chat.type),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      SvgPicture.asset(
                        Assets.svg.calendarBlank.path,
                        height: 14,
                        width: 14,
                        colorFilter: ColorFilter.mode(
                          kTextColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      4.widthBox,
                      Text(
                        shortDate,
                        style: AppStyles.w400f12inter.copyWith(
                          color: kTextColor,
                        ),
                      ),
                    ],
                  ),
                  2.heightBox,
                  Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.w400f12inter.copyWith(color: kTextColor),
                  ),
                ],
              ),
            ),
            8.widthBox,
            SizedBox(
              width: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (hasUnread)
                    Container(
                      decoration: BoxDecoration(
                        color: kDarkTextColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        chat.unreadCount.toString(),
                        style: AppStyles.w500f12inter.copyWith(
                          color: kWhiteColor,
                        ),
                      ).withPaddingSymmetric(8, 4),
                    ),
                  16.heightBox,

                  Text(
                    chat.timeAgo,
                    style: AppStyles.w400f12inter.copyWith(color: kTextColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
