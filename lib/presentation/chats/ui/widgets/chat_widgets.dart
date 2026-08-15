import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/chats/data/models/chat_model.dart';

// ─── Stacked avatar group ────────────────────────────────────────────────────

class _CircleAvatar extends StatelessWidget {
  final ChatParticipant participant;
  final double size;
  final Color borderColor;

  const _CircleAvatar({
    required this.participant,
    required this.size,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1.5),
        color: kGreyColor,
      ),
      child: ClipOval(
        child: participant.avatarUrl != null
            ? Image.network(participant.avatarUrl!, fit: BoxFit.cover)
            : Center(
                child: Text(
                  participant.name[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: size * 0.38,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
      ),
    );
  }
}

class _ExtraCountAvatar extends StatelessWidget {
  final int count;
  final double size;

  const _ExtraCountAvatar({required this.count, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Center(
        child: Text(
          '+$count',
          style: TextStyle(
            fontSize: size * 0.32,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ─── Single participant avatar ───────────────────────────────────────────────


// ─── Unread badge ─────────────────────────────────────────────────────────────

class UnreadBadge extends StatelessWidget {
  final int count;

  const UnreadBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Center(
        child: Text(
          '$count',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ─── Back button ─────────────────────────────────────────────────────────────

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: kDividerColor),
          color: Colors.white,
        ),
        child: const Icon(Icons.arrow_back, size: 18),
      ),
    );
  }
}
