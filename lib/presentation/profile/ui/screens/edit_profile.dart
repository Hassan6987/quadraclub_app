import 'package:image_picker/image_picker.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/utils/components/blue_app_bar.dart';
import 'package:quadraclub_app/utils/components/custom_dialogue.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';
import 'package:quadraclub_app/utils/const/dimensions_resource.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController collegeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  File? _profileImage;
  String? imageUrl;

  bool _isInitialized = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    collegeController.dispose();
    super.dispose();
  }

  void _initializeControllers(UserModel user) {
    if (!_isInitialized) {
      fullNameController.text = user.name ?? '';
      emailController.text = user.email ?? '';
      imageUrl = user.imageUrl;

      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BlueAppBar(title: 'Edit Profile', showBackArrow: true),
      body: Padding(
        padding: EdgeInsets.all(Dim.PADDING_SIZE_DEFAULT),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (BuildContext context, AuthState state) {
            if (state.status == AuthStateStatus.failure) {
              context.showToast(
                state.error ?? 'An error occurred',
                isError: true,
              );
            } else if (state.status == AuthStateStatus.success) {
              _handleSuccess(context);
            }
          },
          builder: (context, state) {
            final user = state.user!;
            _initializeControllers(user);

            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          30.heightBox,
                          _buildProfileImage(),
                          24.heightBox,
                          Container(
                            padding: EdgeInsets.all(Dim.PADDING_SIZE_DEFAULT),
                            decoration: BoxDecoration(
                              color: Color(0xFFF9F4E8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTextField(
                                  'Full Name',
                                  true,
                                  fullNameController,
                                  validator: ValidateForm.fullNameValidator,
                                ),
                                _buildTextField(
                                  'Email',
                                  false,
                                  emailController,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                _buildTextField(
                                  'College Name',
                                  true,
                                  collegeController,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  16.heightBox,
                  if (state.status == AuthStateStatus.updating)
                    Center(child: CustomLoadingView()),
                  if (state.status != AuthStateStatus.updating)
                    CustomActionButton(
                      buttonText: 'Update',
                      onTap: _handleUpdate,
                      backgroundColor: kSecondaryColor,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: kWhiteColor,
            child: CircleAvatar(
              radius: 55,
              backgroundImage: _profileImage != null
                  ? FileImage(_profileImage!)
                  : (imageUrl != null ? NetworkImage(imageUrl!) : null)
                        as ImageProvider?,
              child: imageUrl == null && _profileImage == null
                  ? Icon(Icons.person, size: 50, color: Colors.grey[600])
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                _showImagePickerOptions(context);
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.edit, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    bool enabled,
    TextEditingController controller, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppStyles.bodyRegular.copyWith(color: kBlackColor),
          ),
          8.heightBox,
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            enabled: enabled,
            validator: validator,
            onTapOutside: (_) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: enabled ? kWhiteColor : Colors.grey[300],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            readOnly: !enabled,
            style: AppStyles.bodyRegular.copyWith(color: kBlackColor),
          ),
        ],
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleUpdate() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
      UpdateProfile(
        name: fullNameController.text.trim(),
        college: collegeController.text.trim(),
        profileImage: _profileImage,
      ),
    );
  }

  void _handleSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: 'Updated',
        buttonText: 'Done',
        onButtonTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(Assets.svg.successIcon.path),
            Text(
              'Profile Updated Successfully!',
              style: AppStyles.titleMedium.copyWith(color: kBlackColor),
              textAlign: TextAlign.center,
            ),
            Text(
              'Your changes have been saved.',
              style: AppStyles.subtitleMedium.copyWith(color: kTextColor),
              textAlign: TextAlign.center,
            ),
          ],
        ).withPaddingSymmetric(16, 0),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _profileImage = file;
      });
      if (context.mounted) {
        // context.read<ProfileBloc>().add(SaveImageButtonPressed(file: file));
      }
    }
  }
}
