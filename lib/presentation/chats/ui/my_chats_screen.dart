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
  // 'All' is exclusive; the rest are multi-selectable.
  Set<String> _selectedFilters = {'All'};

  final List<String> _filters = ['All', 'Games', 'Classes', 'Courts'];

  // Maps a filter chip label to the chatType value stored on the chat.
  static const Map<String, String> _filterToChatType = {
    'Games': 'Game',
    'Classes': 'Classroom',
    'Courts': 'Court',
  };

  @override
  void initState() {
    final authState = context.read<AuthBloc>().state;
    if (authState.user == null) {
      return;
    }
    context.read<ChatsBloc>().add(LoadChats());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.user == null) {
          return const GuestLoginPrompt(
            title: 'My Chats',
            subtitle: 'Sign in to view your chats & Conversations',
          );
        }
        return Scaffold(
          appBar: CustomAppBar(
            title: "My Chats",
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
    return Row(
      spacing: 8,
      children: _filters.map(_buildChip).toList(),
    ).withPaddingAll(16);
  }

  Widget _buildChip(String label) {
    final isSelected = _selectedFilters.contains(label);

    return GestureDetector(
      onTap: () => _toggleFilter(label),
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
        .map((f) => _filterToChatType[f])
        .whereType<String>()
        .toSet();

    return chats.where((c) => allowedTypes.contains(c.chatType)).toList();
  }

  Widget _buildChatList() {
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
            return const Center(child: Text('No chats found'));
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];

              return ChatListItem(
                chat: chat,

                // Replace this with the actual logged-in
                // user's ID from your AuthBloc/AuthCubit.
                currentUserId: _currentUserId(context),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ChatScreen(chat: chat)),
                  );
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