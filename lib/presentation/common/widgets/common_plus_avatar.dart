import 'package:dotted_border/dotted_border.dart';

import '../../../app_exports.dart';

class CommonPlusAvatar extends StatelessWidget {
  final double? size;

  const CommonPlusAvatar({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        border: Border.all(color: kWhiteColor, width: 3),
      ),
      child: DottedBorder(
        options: CircularDottedBorderOptions(
          color: kDottedBorderColor,
          dashPattern: [7.5, 5],
        ),
        child: Container(
          width: size ?? 40,
          height: size ?? 40,
          decoration: BoxDecoration(shape: BoxShape.circle, color: kWhiteF9),
          child: const Icon(Icons.add, size: 20, color: Color(0xFFCCCCCC)),
        ),
      ),
    );
  }
}
