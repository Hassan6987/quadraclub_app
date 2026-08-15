import 'package:image_picker/image_picker.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/profile_creation/ui/widgets/profile_creation_app_bar.dart';
import 'package:quadraclub_app/presentation/profile_creation/ui/widgets/profile_photo_upload.dart';
import 'package:quadraclub_app/utils/extensions/padding_extension.dart';

class Step1CreateAccount extends StatefulWidget {
  const Step1CreateAccount({super.key});

  @override
  State<Step1CreateAccount> createState() => _Step1CreateAccountState();
}

class _Step1CreateAccountState extends State<Step1CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _profileImageUrl;
  DateTime? _selectedDate;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );

    if (image != null) {
      setState(() {
        _profileImageUrl = image.path;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 18 * 365)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 13 * 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  void _onContinue() {
Navigator.pushNamed(context, RouteName.otpVerification,arguments: _emailController.text);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: Column(
          children: [
            ProfileCreationAppBar(
              onBackPressed: () => Navigator.pop(context),
              currentStep: 1,
            ),
            24.heightBox,

            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create your account',
                        style: AppStyles.w600f18inter,
                      ),
                      Text(
                        'Fill in your details to start playing.',
                        style: AppStyles.w400f14inter.copyWith(
                          color: kTextSecondary.withValues(alpha: 0.70),
                        ),
                      ),
                      20.heightBox,
                      ProfilePhotoUpload(
                        imageUrl: _profileImageUrl,
                        onPickImage: _pickImage,
                      ),
                      20.heightBox,
                      CustomTextField(
                        controller: _fullNameController,
                        label: 'Full Name',
                        hintText: 'Enter your full name',
                        validator: ValidateForm.fullNameValidator,
                      ),
                      12.heightBox,
                      CustomTextField(
                        controller: _dobController,
                        label: 'Date of Birth',
                        hintText: 'dd/mm/yyyy',
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        suffixIcon: SvgPicture.asset(
                          Assets.svg.calendarBlank.path,
                        ),
                      ),
                      12.heightBox,
                      CustomTextField(
                        controller: _emailController,
                        label: 'Email',
                        hintText: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        validator: ValidateForm.validateEmail,
                      ),
                      12.heightBox,
                      CustomTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hintText: 'Enter your password',
                        obscureText: true,
                        validator: ValidateForm.passwordValidator,
                      ),
                      12.heightBox,
                      CustomTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        hintText: 'Confirm your password',
                        obscureText: true,
                        validator: (value) =>
                            ValidateForm.confirmPasswordValidator(
                              value,
                              _passwordController,
                            ),
                      ),

                      24.heightBox,
                      CustomActionButton(
                        buttonText: "Continue",
                        onTap: _onContinue,
                        isEnabled: true,
                        backgroundColor: kPrimaryColor,
                        buttonTextColor: kTextPrimaryColor,
                      ),
                      24.heightBox,
                    ],
                  ).withPaddingSymmetric(24, 0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
