import 'package:intl/intl.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/chats/ui/widgets/message_tile.dart';


class GroupChatScreen extends StatefulWidget {
  final GroupChatDetail detail;

  const GroupChatScreen({super.key, required this.detail});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.detail.messages);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: 'me',
          senderName: 'You',
          text: text,
          sentAt: DateTime.now(),
          isMe: true,
        ),
      );
      _controller.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Group messages by day
  Map<String, List<ChatMessage>> get _groupedMessages {
    final Map<String, List<ChatMessage>> groups = {};
    for (final msg in _messages) {
      final key = _dayLabel(msg.sentAt);
      groups.putIfAbsent(key, () => []).add(msg);
    }
    return groups;
  }

  String _dayLabel(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final msgDay = DateTime(dt.year, dt.month, dt.day);
    if (msgDay == today) return 'TODAY';
    if (msgDay == today.subtract(const Duration(days: 1))) return 'YESTERDAY';
    return DateFormat('MMM d, yyyy').format(dt).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Group Chat",
        subtitle: "Mixed Doubles Match",
        titleStyle: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
        showBackIcon: true,
        showActions: false,
      ),
      body: Column(
        children: [
          _buildParticipantBanner(),
          Expanded(child: _buildMessageList()),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildParticipantBanner() {
    final imgUrls = widget.detail.participants.map((e) => e.avatarUrl).toList();
    return Container(
      color: kPrimaryColor.withValues(alpha: 0.20),
      child: Row(
        children: [
          StackedAvatars(avatarSize: 30, imgUrls: imgUrls),
          8.widthBox,
          Text(
            '${widget.detail.participants.length} players in chat',
            style: AppStyles.w400f14inter.copyWith(color: kDarkTextColor),
          ),
        ],
      ).withPaddingSymmetric(16, 8),
    );
  }

  Widget _buildMessageList() {
    final groups = _groupedMessages;
    final keys = groups.keys.toList();

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final dayKey = keys[index];
        final dayMessages = groups[dayKey]!;
        return Column(
          children: [
            DateContainer(label: dayKey),
            ...dayMessages.map((msg) => MessageTile(message: msg)),
            if (index == keys.length - 1) ...[
              const SizedBox(height: 8),
              GroupJoinedMessage(
                text:
                    '${widget.detail.participants.last.name} joined the match group',
                highlightName: widget.detail.participants.last.name,
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: kWhiteColor,
        border: Border(top: BorderSide(color: kDividerColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: _controller,
              borderRadius: 1000,
              hintText: "Type your message",
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          8.widthBox,
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimaryColor,
              ),
              child: const Icon(Icons.send_rounded, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Date separator ───────────────────────────────────────────────────────────

class DateContainer extends StatelessWidget {
  final String label;

  const DateContainer({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor.withValues(alpha: 0.40),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: kDividerColor),
      ),
      child: Text(
        label,
        style: AppStyles.w500f10inter.copyWith(color: kTextColor),
      ).withPaddingSymmetric(8, 4),
    );
  }
}

// ─── Message bubble ───────────────────────────────────────────────────────────

class GroupJoinedMessage extends StatelessWidget {
  final String text;
  final String highlightName;

  const GroupJoinedMessage({required this.text, required this.highlightName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor.withValues(alpha: 0.40),
        border: Border.all(color: kBorderColor),
        borderRadius: BorderRadius.circular(100),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: highlightName,
              style: AppStyles.w500f12inter.copyWith(
                color: kBlueColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: text.replaceFirst(highlightName, ''),
              style: AppStyles.w400f12inter.copyWith(color: kDarkTextColor),
            ),
          ],
        ),
      ).withPaddingSymmetric(8, 4),
    );
  }
}
