import 'package:intl/intl.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/di/locator.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/chats/bloc/chats_bloc.dart';
import 'package:quadraclub_app/presentation/chats/message_bloc/chat_bloc.dart';
import 'package:quadraclub_app/presentation/chats/ui/widgets/message_tile.dart';
import 'package:quadraclub_app/presentation/classes/data/classes_repo.dart';
import 'package:quadraclub_app/presentation/classes/ui/class_details_screen.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';

class AgendaChatScreen extends StatefulWidget {
  final String chatId;
  final String label;
  final int userCount;

  /// When set (class chats), tapping the header opens class details.
  final String? classId;

  const AgendaChatScreen({
    super.key,
    required this.chatId,
    required this.label,
    required this.userCount,
    this.classId,
  });

  @override
  State<AgendaChatScreen> createState() => _AgendaChatScreenState();
}

class _AgendaChatScreenState extends State<AgendaChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _openingDetails = false;

  @override
  void initState() {
    super.initState();

    final bloc = context.read<ChatBloc>();

    bloc.add(LoadMessages(widget.chatId));

    bloc.add(JoinChat(widget.chatId));

    _markChatReadLocally();
  }

  void _markChatReadLocally() {
    final userId = context.read<AuthBloc>().state.user?.id ?? '';
    if (userId.isEmpty || widget.chatId.isEmpty) return;

    context.read<ChatsBloc>().add(
      MarkChatReadLocally(chatId: widget.chatId, userId: userId),
    );
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
      SendMessage(chatId: widget.chatId, content: text),
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

  Future<void> _openClassDetails() async {
    final classId = widget.classId;
    if (classId == null || classId.isEmpty) return;
    if (_openingDetails) return;

    setState(() => _openingDetails = true);

    try {
      final classModel = await locator.get<ClassesRepo>().getClassById(classId);
      if (!mounted) return;

      final distance = (classModel.distanceKm is num)
          ? (classModel.distanceKm as num).toDouble()
          : 0.0;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ClassDetailsScreen(
            classModel: classModel,
            distanceKm: distance,
            isFromClass: false,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      context.showToast(
        AppLocalizations.of(context)!.somethingWentWrong,
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _openingDetails = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canOpenClass = widget.classId != null && widget.classId!.isNotEmpty;

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.label,
        subtitle: l10n.playersCount(widget.userCount),
        titleStyle: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
        showBackIcon: true,
        showActions: false,
        onTitleTap: canOpenClass ? _openClassDetails : null,
      ),
      body: Stack(
        children: [
          BlocConsumer<ChatBloc, ChatState>(
            listener: (context, state) {
              if (state is ChatLoaded) {
                _scrollToBottom();
                _markChatReadLocally();
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
                    Expanded(child: _buildMessageList(state.messages)),

                    _buildInputBar(isSending: state.isSending),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
          if (_openingDetails)
            const ColoredBox(
              color: Color(0x33000000),
              child: Center(child: CustomLoadingView()),
            ),
        ],
      ),
    );
  }

  String _dayLabel(DateTime dt) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final msgDay = DateTime(dt.year, dt.month, dt.day);
    if (msgDay == today) return l10n.today;
    if (msgDay == today.subtract(const Duration(days: 1))) {
      return l10n.yesterday;
    }
    return DateFormat('MMM d, yyyy', l10n.localeName).format(dt).toUpperCase();
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
              hintText: AppLocalizations.of(context)!.typeYourMessage,
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
