import 'package:intl/intl.dart';
import 'package:quadraclub_app/presentation/chats/ui/widgets/single_avatar.dart';
import 'package:quadraclub_app/presentation/matches/ui/player_profile_screen.dart';

import '/app_exports.dart';

class MessageTile extends StatelessWidget {
  final ChatMessage message;
  final String currentUserId;

  const MessageTile({
    super.key,
    required this.message,
    required this.currentUserId,
  });

  void _openProfile(BuildContext context) {
    final id = message.sender.id;
    if (id.isEmpty || id == currentUserId) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlayerProfileScreen(playerId: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final isMe = message.sender.id == currentUserId;

    final timeStr = DateFormat(
      'h:mm a',
      l10n.localeName,
    ).format(message.createdAt);

    if (isMe) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              l10n.you,
              style: AppStyles.w500f10inter.copyWith(color: kTextColor),
            ).paddingOnly(right: 32),

            4.heightBox,

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      message.content,
                      style: AppStyles.w400f14inter.copyWith(
                        color: kDarkTextColor,
                      ),
                    ),
                  ),
                ),

                6.widthBox,

                SmallAvatar(size: 24, url: message.sender.profilePhoto ?? ''),
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
          GestureDetector(
            onTap: () => _openProfile(context),
            child: Text(
              message.sender.fullName.toUpperCase(),
              style: AppStyles.w500f10inter.copyWith(color: kTextColor),
            ).paddingOnly(left: 32),
          ),

          4.heightBox,

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => _openProfile(context),
                child: SmallAvatar(
                  size: 24,
                  url: message.sender.profilePhoto ?? '',
                ),
              ),

              6.widthBox,

              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    border: Border.all(color: kBorderColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    message.content,
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
