import 'package:image_picker/image_picker.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/utils/components/blue_app_bar.dart';
import 'package:quadraclub_app/utils/components/custom_dialogue.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';
import 'package:quadraclub_app/utils/const/dimensions_resource.dart';
import 'package:quadraclub_app/utils/extensions/padding_extension.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController collegeController = TextEditingController();

  // Three link controllers
  final TextEditingController link1Controller = TextEditingController();
  final TextEditingController link2Controller = TextEditingController();
  final TextEditingController link3Controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  File? _profileImage;
  String? imageUrl;

  bool _isInitialized = false;

  // Store initial link data
  String _initialLink1 = '';
  String _initialLink2 = '';
  String _initialLink3 = '';

  int? _link1Id;
  int? _link2Id;
  int? _link3Id;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    collegeController.dispose();
    link1Controller.dispose();
    link2Controller.dispose();
    link3Controller.dispose();
    super.dispose();
  }

  void _initializeControllers(UserModel user) {
    if (!_isInitialized) {
      fullNameController.text = user.profile?.fullName ?? '';
      emailController.text = user.email ?? '';
      collegeController.text = user.profile?.collegeName ?? '';
      imageUrl = user.profile?.image;

      // Initialize link controllers with first three links
      final links = user.profile?.links ?? [];

      if (links.isNotEmpty) {
        _link1Id = links[0].id;
        _initialLink1 = links[0].url ?? '';
        link1Controller.text = _initialLink1;
      }

      if (links.length > 1) {
        _link2Id = links[1].id;
        _initialLink2 = links[1].url ?? '';
        link2Controller.text = _initialLink2;
      }

      if (links.length > 2) {
        _link3Id = links[2].id;
        _initialLink3 = links[2].url ?? '';
        link3Controller.text = _initialLink3;
      }

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
                                _buildTextField(
                                  'Link 1',
                                  true,
                                  link1Controller,
                                  validator: ValidateForm.validateLink,
                                  keyboardType: TextInputType.url,
                                ),
                                _buildTextField(
                                  'Link 2',
                                  true,
                                  link2Controller,
                                  validator: ValidateForm.validateLink,
                                  keyboardType: TextInputType.url,
                                ),
                                _buildTextField(
                                  'Link 3',
                                  true,
                                  link3Controller,
                                  validator: ValidateForm.validateLink,
                                  keyboardType: TextInputType.url,
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
    // Handle Link 1
    _handleLinkChange(
      currentValue: link1Controller.text.trim(),
      initialValue: _initialLink1,
      linkId: _link1Id,
    );

    // Handle Link 2
    _handleLinkChange(
      currentValue: link2Controller.text.trim(),
      initialValue: _initialLink2,
      linkId: _link2Id,
    );

    // Handle Link 3
    _handleLinkChange(
      currentValue: link3Controller.text.trim(),
      initialValue: _initialLink3,
      linkId: _link3Id,
    );

    context.read<AuthBloc>().add(
      UpdateProfile(
        name: fullNameController.text.trim(),
        college: collegeController.text.trim(),
        profileImage: _profileImage,
      ),
    );
  }

  void _handleLinkChange({
    required String currentValue,
    required String initialValue,
    required int? linkId,
  }) {
    final isInitiallyEmpty = initialValue.isEmpty;
    final isCurrentlyEmpty = currentValue.isEmpty;

    // Case 1: Link was empty, now has value -> Add Link
    if (isInitiallyEmpty && !isCurrentlyEmpty) {
      context.read<AuthBloc>().add(AddLink(url: currentValue));
    }
    // Case 2: Link had value, now empty -> Delete Link
    else if (!isInitiallyEmpty && isCurrentlyEmpty && linkId != null) {
      context.read<AuthBloc>().add(DeleteLink(id: linkId));
    }
    // Case 3: Link had value, still has value but changed -> Update Link
    else if (!isInitiallyEmpty &&
        !isCurrentlyEmpty &&
        currentValue != initialValue &&
        linkId != null) {
      context.read<AuthBloc>().add(UpdateLink(id: linkId, url: currentValue));
    }
    // Case 4: No change -> Do nothing
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
            SvgPicture.asset(Assets.svgSuccessIcon),
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
