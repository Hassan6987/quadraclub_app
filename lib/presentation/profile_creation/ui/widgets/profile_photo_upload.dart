import 'package:image_picker/image_picker.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/utils/extensions/padding_extension.dart';

class ProfilePhotoUpload extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onPickImage;

  const ProfilePhotoUpload({
    super.key,
    this.imageUrl,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        GestureDetector(
          onTap: onPickImage,
          child: Container(
            width: getProportionateScreenWidth(50),
            height: getProportionateScreenHeight(50),
            decoration: BoxDecoration(
              color: kGreyColor,
              borderRadius: BorderRadius.circular(8),

            ),
            child: imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholder().withPaddingAll(16);
                      },
                    ),
                  )
                : _buildPlaceholder().withPaddingAll(16),
          ),
        ),
        8.widthBox,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Photo',
              style: AppStyles.w500f14inter.copyWith(
                color: kDarkColor,
              ),
            ),
            2.heightBox,
            Text(
              'JPG or PNG, max 5MB',
              style: AppStyles.w400f14inter.copyWith(
                color: kTextColor,
              ),
            ),
          ],
        )

      ],
    );
  }

  Widget _buildPlaceholder() {
    return SvgPicture.asset(Assets.svg.uploadPhoto.path);
  }
}
