import '../../app_exports.dart';

class CommonSuccessCheck extends StatelessWidget {
  const CommonSuccessCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: kPrimaryColor, width: 12),
      ),
      child: const Center(
        child: Icon(Icons.check, size: 30, color: kDarkTextColor),
      ),
    );
  }
}
