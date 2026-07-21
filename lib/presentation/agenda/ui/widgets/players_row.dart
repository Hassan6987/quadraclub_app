import 'package:quadraclub_app/presentation/common/widgets/common_plus_avatar.dart';
import '../../../../app_exports.dart';

class PlayersRow extends StatelessWidget {
  const PlayersRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _player(playerOneImageUrl, 'Alex', 'Beginner'),
        _player(playerTwoImageUrl, 'John', 'Beginner'),
        Container(width: 1, height: 24, color: kGreyB8),
        _availableSlot('Available', 'Left'),
        _availableSlot('Available', 'Right'),
      ],
    );
  }
}

Widget _player(String image, String name, String subtitle) {
  return  Column(
    children: [
      AppCachedImage(
        imageUrl: image,
        height: 40,
        width: 40,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(40),
      ),
      6.heightBox,
      Text(
        name,
        style: AppStyles.w500f14inter.copyWith(
          color: kDarkTextColor,
          fontWeight:FontWeight.w500,
        ),
      ),
      Text(
        subtitle,
        style: AppStyles.w400f12inter.copyWith(color: kGreyTextColor),
      ),
    ],
  );

}

Widget _availableSlot(String name, String subtitle) {
  return Column(
    children: [
    CommonPlusAvatar(size: 34),
      6.heightBox,
      Text(
        name,
        style: AppStyles.w500f14inter.copyWith(
          color: kDarkTextColor,
          fontWeight:  FontWeight.w400 ,
        ),
      ),
      Text(
        subtitle,
        style: AppStyles.w400f12inter.copyWith(color: kGreyTextColor),
      ),
    ],
  );
}



