import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/chats/ui/widgets/chat_item.dart';

class MyChatsScreen extends StatefulWidget {
  const MyChatsScreen({super.key});

  @override
  State<MyChatsScreen> createState() => _MyChatsScreenState();
}

class _MyChatsScreenState extends State<MyChatsScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Games', 'Classes', 'Courts'];

  List<ChatPreview> get _filteredChats {
    final chats = ChatDummyData.chatPreviews;
    if (_selectedFilter == 'All') return chats;
    if (_selectedFilter == 'Games') {
      return chats.where((c) => c.type == ChatType.game).toList();
    }
    if (_selectedFilter == 'Classes') {
      return chats.where((c) => c.type == ChatType.classroom).toList();
    }
    return chats;
  }

  @override
  Widget build(BuildContext context) {
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
      onTap: () => setState(() => _selectedFilter = label),
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

  Widget _buildChatList() {
    final chats = _filteredChats;
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: chats.length,

      itemBuilder: (context, index) => ChatListItem(
        chat: chats[index],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                GroupChatScreen(detail: ChatDummyData.groupChatDetail),
          ),
        ),
      ),
    );
  }
}
