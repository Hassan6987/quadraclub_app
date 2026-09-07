import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/chats/bloc/chats_bloc.dart';
import 'package:quadraclub_app/presentation/chats/ui/widgets/chat_item.dart';

class MyChatsScreen extends StatefulWidget {
  const MyChatsScreen({super.key});

  @override
  State<MyChatsScreen> createState() => _MyChatsScreenState();
}

class _MyChatsScreenState extends State<MyChatsScreen> {
  String _selectedFilter = 'All';

  @override
  void initState() {
    context.read<ChatsBloc>().add(LoadChats());
    super.initState();
  }

  final List<String> _filters = [
    'All',
    'Games',
    'Classes',
    'Courts',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "My Chats",
        titleStyle: AppStyles.w600f16inter.copyWith(
          color: kDarkTextColor,
        ),
        showBackIcon: true,
        showActions: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterChips(),
          const SizedBox(height: 8),
          Expanded(
            child: _buildChatList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Row(
      spacing: 8,
      children: _filters.map(_buildChip).toList(),
    ).withPaddingAll(16);
  }

  Widget _buildChip(String label) {
    final isSelected = _selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
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
          style: AppStyles.w400f14inter.copyWith(
            color: kDarkTextColor,
          ),
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return BlocBuilder<ChatsBloc, ChatsState>(
      builder: (context, state) {
        if (state is ChatsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ChatsError) {
          return Center(
            child: Text(state.message),
          );
        }

        if (state is ChatsLoaded) {
          final chats = state.chats;

          if (chats.isEmpty) {
            return const Center(
              child: Text('No chats found'),
            );
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
                    MaterialPageRoute(
                      builder: (_) =>
                          ChatScreen(
                            chat: chat,
                          ),
                    ),
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
    return context
        .read<AuthBloc>()
        .state
        .user
        ?.id ?? '';
  }
}