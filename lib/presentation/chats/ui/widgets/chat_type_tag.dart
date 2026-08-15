import '/app_exports.dart';

class ChatTypeTag extends StatelessWidget {
  final ChatType type;

  const ChatTypeTag({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final isGame = type == ChatType.game;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(6),
        vertical: getProportionateScreenHeight(5),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isGame
            ? kBlueF1.withValues(alpha: 0.20)
            : kGreenColor.withValues(alpha: 0.20),
        border: Border.all(color: isGame ? kBlueF1 : kGreenColor,width: 0.8),
      ),
      child: Text(
        isGame ? 'Game' : 'Classroom',
        style: AppStyles.w500f10inter.copyWith(
          color: isGame ? kBlueF1 : kGreenColor,
        ),
      ),
    );
  }
}
