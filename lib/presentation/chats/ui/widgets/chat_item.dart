import 'package:intl/intl.dart';

import '/app_exports.dart';

class ChatListItem extends StatelessWidget {
  final Chat chat;
  final VoidCallback onTap;

  /// Pass the logged-in user's ID here.
  final String currentUserId;

  const ChatListItem({
    super.key,
    required this.chat,
    required this.onTap,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final latestMessage = chat.latestMessage;

    // A message is unread for the current user when
    // the current user's ID is NOT inside seenBy.
    final bool hasUnread =
        latestMessage != null && !latestMessage.seenBy.contains(currentUserId);

    final String timeAgo = latestMessage == null
        ? ''
        : _formatTimeAgo(latestMessage.createdAt);

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
            // Avatars
            if (chat.users.isNotEmpty)
              StackedAvatars(
                imgUrls: chat.users.map((user) => user.profilePhoto).toList(),
              )
            else
              AppCachedImage(
                borderRadius: BorderRadius.circular(200),
                height: 32,
                width: 32,
                imageUrl: '',
              ),

            12.widthBox,

            // Chat information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.chatName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.w500f14inter.copyWith(
                      color: kTextPrimaryColor,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    latestMessage?.content ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.w400f12inter.copyWith(color: kTextColor),
                  ),
                ],
              ),
            ),

            8.widthBox,

            // Unread + time
            SizedBox(
              width: 45,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (hasUnread)
                    Container(
                      decoration: const BoxDecoration(
                        color: kDarkTextColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '1',
                        style: TextStyle(
                          color: kWhiteColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ).withPaddingSymmetric(8, 4),
                    ),

                  if (hasUnread) 12.heightBox,

                  Text(
                    timeAgo,
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

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours}h';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays}d';
    }

    return DateFormat('MMM d').format(dateTime);
  }
}
