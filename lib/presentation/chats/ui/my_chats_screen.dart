import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/chats/bloc/chats_bloc.dart';
import 'package:quadraclub_app/presentation/chats/ui/widgets/chat_item.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';

class MyChatsScreen extends StatefulWidget {
  const MyChatsScreen({super.key});

  @override
  State<MyChatsScreen> createState() => _MyChatsScreenState();
}

class _MyChatsScreenState extends State<MyChatsScreen> {
  // Internal values remain English/canonical.
  // 'All' is exclusive; the rest are multi-selectable.
  Set<String> _selectedFilters = {'All'};

  final List<String> _filters = ['All', 'Games', 'Classes', 'Courts'];

  // Maps the internal filter value to the chatType
  // value stored on the chat/API.
  static const Map<String, String> _filterToChatType = {
    'Games': 'Game',
    'Classes': 'Classroom',
    'Courts': 'Court',
  };

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;

    if (authState.user == null) {
      return;
    }

    context.read<ChatsBloc>().add(LoadChats());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.user == null) {
          return GuestLoginPrompt(
            title: l10n.myChats,
            showAction: false,
            subtitle: l10n.signInToViewYourChatsAndConversations,
          );
        }

        return Scaffold(
          appBar: CustomAppBar(
            title: l10n.myChats,
            titleStyle: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
            showBackIcon: true,
            showActions: false,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilterChips(),
              const SizedBox(height: 8),
              Expanded(child: _buildChatList()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChips() {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      spacing: 8,
      children: _filters.map((filter) {
        return _buildChip(filter, _getFilterLabel(l10n, filter));
      }).toList(),
    ).withPaddingAll(16);
  }

  String _getFilterLabel(AppLocalizations l10n, String filter) {
    switch (filter) {
      case 'All':
        return l10n.all;
      case 'Games':
        return l10n.games;
      case 'Classes':
        return l10n.classes;
      case 'Courts':
        return l10n.courts;
      default:
        return filter;
    }
  }

  Widget _buildChip(String value, String label) {
    final isSelected = _selectedFilters.contains(value);

    return GestureDetector(
      onTap: () => _toggleFilter(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(12),
          vertical: getProportionateScreenHeight(6),
        ),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor : kGreyColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: AppStyles.w400f14inter.copyWith(color: kDarkTextColor),
        ),
      ),
    );
  }

  void _toggleFilter(String label) {
    setState(() {
      if (label == 'All') {
        _selectedFilters = {'All'};
        return;
      }

      _selectedFilters.remove('All');

      if (_selectedFilters.contains(label)) {
        _selectedFilters.remove(label);
      } else {
        _selectedFilters.add(label);
      }

      // Never end up with nothing selected — fall back to All.
      if (_selectedFilters.isEmpty) {
        _selectedFilters = {'All'};
      }
    });
  }

  List<Chat> _applyFilters(List<Chat> chats) {
    if (_selectedFilters.contains('All')) {
      return chats;
    }

    final allowedTypes = _selectedFilters
        .map((filter) => _filterToChatType[filter])
        .whereType<String>()
        .toSet();

    return chats.where((chat) => allowedTypes.contains(chat.chatType)).toList();
  }

  Widget _buildChatList() {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ChatsBloc, ChatsState>(
      builder: (context, state) {
        if (state is ChatsLoading) {
          return const Center(child: CustomLoadingView());
        }

        if (state is ChatsError) {
          return Center(child: Text(state.message));
        }

        if (state is ChatsLoaded) {
          final chats = _applyFilters(state.chats);

          if (chats.isEmpty) {
            return Center(child: Text(l10n.noChatsFound));
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];

              return ChatListItem(
                chat: chat,
                currentUserId: _currentUserId(context),
                onTap: () {
                  final userId = _currentUserId(context);
                  if (userId.isNotEmpty) {
                    context.read<ChatsBloc>().add(
                      MarkChatReadLocally(chatId: chat.id, userId: userId),
                    );
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ChatScreen(chat: chat)),
                  ).then((_) {
                    if (context.mounted) {
                      context.read<ChatsBloc>().add(LoadChats());
                    }
                  });
                },
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  String _currentUserId(BuildContext context) {
    return context.read<AuthBloc>().state.user?.id ?? '';
  }
}
