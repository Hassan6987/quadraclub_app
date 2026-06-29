import 'package:quadraclub_app/utils/app_utils.dart';
import 'package:quadraclub_app/utils/image_picker_util.dart';

import '../../../app_exports.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(
    text: "samiiiolle@gmail.com",
  );
  File? _image;
  Future<void> _onTapChangePhoto() async {
    final File? img = await ImagePickerUtil.pickFromGallery(context);
    if (img != null) {
      setState(() {
        _image = File(img.path);
      });
    }
  }

  Future<void> _onSelectDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _dobController.text = AppUtils.getFormattedDateWithSlash(date);
      });
    }
  }
  @override
  void initState() {
    super.initState();
  }
@override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "My Account",
        showActions: false,
        centerTile: true,
        showBackIcon: true,
        titleStyle: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
      ),
      backgroundColor: kCardColor,
      body: Column(
        children: [
          _buildHeader(),
          32.heightBox,
          CustomTextField(
            label: "Name",
            controller: _nameController,
            hintText: "Enter your name",
            prefixIcon: SvgPicture.asset(Assets.svg.accontIcon.path),
            keyboardType: TextInputType.name,
          ),
          12.heightBox,
          CustomTextField(
            label: "Location",
            controller: _locationController,
            hintText: "Enter your location",
            prefixIcon: SvgPicture.asset(Assets.svg.mapMarker.path),
          ),
          12.heightBox,
          CustomTextField(
            controller: _dobController,
            label: 'Date of Birth',
            hintText: 'dd/mm/yyyy',
            readOnly: true,
            onTap: () => _onSelectDate(),
            suffixIcon: SvgPicture.asset(Assets.svg.calendarBlank.path),
          ),
          12.heightBox,
          CustomTextField(
            label: "Email (Can’t Change)",
            controller: _emailController,
            readOnly: true,
            hintText: "Enter your email",
            textStyle: AppStyles.w400f14inter.copyWith(
              color: kTextSecondary.withValues(alpha: 0.50),
            ) ,
            prefixIcon: SvgPicture.asset(Assets.svg.emailIcon.path),
            keyboardType: TextInputType.emailAddress,
          ),
          Spacer(),
          CustomActionButton(
            buttonText: "Update",
            onTap: () {},

          ),
        ],
      ).withPaddingAll(24),
    );
  }

  Row _buildHeader() {
    return Row(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          clipBehavior: Clip.none,
          children: [
            AppCachedImage(
              borderRadius: BorderRadius.circular(20),
              localFile: _image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            Positioned(
              right: -10,
              bottom: -10,
              child: InkWell(
                onTap: _onTapChangePhoto,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: kBorderColor),
                  ),
                  child: SvgPicture.asset(Assets.svg.uploadPhoto.path),
                ),
              ),
            ),
          ],
        ),
        20.widthBox,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Photo',
              style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
            ),
            Text(
              'JPG or PNG, max 5MB.',
              style: AppStyles.w400f14inter.copyWith(color: kTextColor),
            ),
          ],
        ),
      ],
    );
  }
}
