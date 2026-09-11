import 'package:intl/intl.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/chats/message_bloc/chat_bloc.dart';
import 'package:quadraclub_app/presentation/chats/ui/widgets/message_tile.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;

  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final bloc = context.read<ChatBloc>();

    bloc.add(LoadMessages(widget.chat.id));

    bloc.add(JoinChat(widget.chat.id));
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

    context.read<ChatBloc>().add(
      SendMessage(chatId: widget.chat.id, content: text),
    );

    _controller.clear();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String _currentUserId(BuildContext context) {
    return context.read<AuthBloc>().state.user?.id ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.chat.chatName,
        subtitle: widget.chat.isGroupChat
            ? '${widget.chat.users.length} players'
            : null,
        titleStyle: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
        showBackIcon: true,
        showActions: false,
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatLoaded) {
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ChatError) {
            return Center(child: Text(state.message));
          }

          if (state is ChatLoaded) {
            return Column(
              children: [
                if (widget.chat.isGroupChat) _buildParticipantBanner(),

                Expanded(child: _buildMessageList(state.messages)),

                _buildInputBar(isSending: state.isSending),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _dayLabel(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final msgDay = DateTime(dt.year, dt.month, dt.day);
    if (msgDay == today) return 'TODAY';
    if (msgDay == today.subtract(const Duration(days: 1))) return 'YESTERDAY';
    return DateFormat('MMM d, yyyy').format(dt).toUpperCase();
  }

  Widget _buildParticipantBanner() {
    final imgUrls = widget.chat.users.map((e) => e.profilePhoto).toList();
    return Container(
      color: kPrimaryColor.withValues(alpha: 0.20),
      child: Row(
        children: [
          StackedAvatars(avatarSize: 30, imgUrls: imgUrls),
          8.widthBox,
          Text(
            '${widget.chat.users.length} players in chat',
            style: AppStyles.w400f14inter.copyWith(color: kDarkTextColor),
          ),
        ],
      ).withPaddingSymmetric(16, 8),
    );
  }

  Widget _buildMessageList(List<ChatMessage> messages) {
    final groups = <String, List<ChatMessage>>{};

    for (final message in messages) {
      final key = _dayLabel(message.createdAt);
      groups.putIfAbsent(key, () => []).add(message);
    }
    final keys = groups.keys.toList();

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final dayKey = keys[index];

        final dayMessages = groups[dayKey]!;

        return Column(
          children: [
            DateContainer(label: dayKey),

            ...dayMessages.map((message) {
              return MessageTile(
                message: message,
                currentUserId: _currentUserId(context),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildInputBar({required bool isSending}) {
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
