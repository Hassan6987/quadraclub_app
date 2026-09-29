import 'package:intl/intl.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final latestMessage = chat.latestMessage;

    final bool hasUnread =
        latestMessage != null && !latestMessage.seenBy.contains(currentUserId);

    final String timeAgo = latestMessage == null
        ? _formatTimeAgo(chat.updatedAt, l10n)
        : _formatTimeAgo(latestMessage.createdAt, l10n);

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
          horizontal: getProportionateScreenWidth(12),
          vertical: getProportionateScreenHeight(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: (chat.users.isNotEmpty)
                  ? StackedAvatars(
                      imgUrls: chat.users
                          .map((user) => user.profilePhoto)
                          .toList(),
                    )
                  : AppCachedImage(
                      borderRadius: BorderRadius.circular(200),
                      height: 52,
                      width: 52,
                      imageUrl: '',
                    ),
            ),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          chat.chatName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.w500f14inter.copyWith(
                            color: kTextPrimaryColor,
                          ),
                        ),
                      ),
                      4.widthBox,
                      _chatTypeBadge(
                        chat.chatType,
                        chat.isClassroom ? kGreen06 : kBlueColor,
                      ),
                    ],
                  ),
                  2.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: kChatMessageColor,
                      ),
                      Text(
                        chat.metaInfo?.dateTime ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.w400f12inter.copyWith(
                          color: kChatMessageColor,
                        ),
                      ),
                    ],
                  ),
                  2.heightBox,
                    Text(
                      latestMessage!= null?
                      "${_getSenderName(context,latestMessage.sender.fullName, latestMessage.sender.id)} : ${latestMessage.content}"
                      : "New Group Created",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.w400f12inter.copyWith(color: kTextColor),
                    ),
                ],
              ),
            ),
            Expanded(
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

  String _formatTimeAgo(DateTime dateTime, AppLocalizations l10n) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return l10n.now;
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

    return DateFormat('MMM d', l10n.localeName).format(dateTime);
  }

  String _getSenderName(BuildContext context, String name, String id) {
    final currentUserId = context.read<AuthBloc>().state.user?.id;

    if (currentUserId == id) {
      return "You";
    }
    return name.trim().split(RegExp(r'\s+')).first;
  }

  Widget _chatTypeBadge(String label,Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.10),
      border: Border.all(color: color),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(label, style: AppStyles.w500f10inter.copyWith(color: color)),
  );
}
