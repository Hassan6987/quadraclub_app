import 'dart:developer';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/authentication/data/model/signup_data.dart';
import 'package:quadraclub_app/presentation/authentication/ui/signup/onboarding_app_bar.dart';
import 'package:quadraclub_app/presentation/authentication/ui/signup/otp_verification_screen.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';
import 'package:quadraclub_app/utils/const/dimensions_resource.dart';

import '/app_exports.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final SignupData _data = SignupData();

  final _fullNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final bool _obscurePassword = true;
  final bool _obscureConfirmPassword = true;

  bool get _isButtonEnabled =>
      _fullNameController.text.isNotEmpty &&
          _dobController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    for (final controller in [
      _fullNameController,
      _dobController,
      _emailController,
      _passwordController,
      _confirmPasswordController,
    ]) {
      controller.addListener(() => setState(() {}));
    }
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

  Future<void> _pickDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _data.dateOfBirth = picked;
      _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {});
    }
  }

  Future<void> _pickProfilePhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _data.profilePhotoPath = picked.path);
  }

  void _onContinue() {
    if (!_isButtonEnabled) return;
    if (_formKey.currentState!.validate()) {
      _data
        ..fullName = _fullNameController.text.trim()
        ..email = _emailController.text.trim()
        ..password = _passwordController.text;

      context.read<AuthBloc>().add(SignUpEvent(data: _data));
    }
  }

  @override
  Widget build(BuildContext context) {
    log("Rebuilding ....");
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStateStatus.success) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OtpVerificationScr(data: _data)),
          );
        } else if (state.status == AuthStateStatus.failure) {
          context.showToast(
              state.error ?? 'Something went wrong', isError: true);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: kWhiteColor,
          appBar: const OnboardingAppBar(currentStep: 1, totalSteps: 5),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: Dim.PADDING_SIZE_LARGE),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  24.heightBox,
                  Text(
                    "Create your account",
                    style: AppStyles.headingSemibold.copyWith(
                      color: kBlackColor,
                    ),
                  ),
                  Text(
                    "Fill in your details to start playing.",
                    style: AppStyles.subtitleRegular.copyWith(
                      color: kTextColor,
                    ),
                  ),
                  20.heightBox,
                  GestureDetector(
                    onTap: _pickProfilePhoto,
                    child: Row(
                      children: [
                        Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            color: kBorderColor.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(8),
                            image: _data.profilePhotoPath != null
                                ? DecorationImage(
                              image: FileImage(
                                File(_data.profilePhotoPath!),
                              ),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          child: _data.profilePhotoPath == null
                              ? Icon(
                            Icons.add_a_photo_outlined,
                            color: kTextColor,
                          )
                              : null,
                        ),
                        12.widthBox,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Profile Photo",
                              style: AppStyles.w500f14inter.copyWith(
                                color: kBlackColor,
                              ),
                            ),
                            Text(
                              "JPG or PNG, max 5MB",
                              style: AppStyles.w400f12inter.copyWith(
                                color: kTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  20.heightBox,
                  CustomTextField(
                    label: "Full Name",
                    controller: _fullNameController,
                    hintText: "Enter your name",
                    validator: ValidateForm.fullNameValidator,
                  ),
                  12.heightBox,
                  CustomTextField(
                    label: "Date of Birth",
                    controller: _dobController,
                    hintText: "dd/mm/yyyy",
                    readOnly: true,
                    onTap: _pickDateOfBirth,
                    suffixIcon: const Icon(Icons.calendar_today_outlined),
                    validator: (v) =>
                    (v == null || v.isEmpty)
                        ? "Date of birth is required"
                        : null,
                  ),
                  12.heightBox,
                  CustomTextField(
                    label: "Email",
                    controller: _emailController,
                    hintText: "Enter your email",
                    keyboardType: TextInputType.emailAddress,
                    validator: ValidateForm.validateEmail,
                  ),
                  12.heightBox,
                  CustomTextField(
                    label: "Password",
                    controller: _passwordController,
                    hintText: "Enter your password",
                    obscureText: _obscurePassword,
                    validator: ValidateForm.passwordValidator,
                  ),
                  12.heightBox,
                  CustomTextField(
                    label: "Confirm Password",
                    controller: _confirmPasswordController,
                    hintText: "Confirm your password",
                    obscureText: _obscureConfirmPassword,
                    validator: (v) =>
                        ValidateForm.confirmPasswordValidator(
                          v,
                          _passwordController.text,
                        ),
                  ),
                  32.heightBox,
                  if(state.status == AuthStateStatus.loading)
                    Center(child: CustomLoadingView()),
                  if(state.status != AuthStateStatus.loading)
                    CustomActionButton(
                      buttonText: "Continue",
                      onTap: _onContinue,
                      isEnabled: _isButtonEnabled,
                      backgroundColor: const Color(0xFFC5E028),
                      buttonTextColor: kBlackColor,
                      width: double.infinity,
                    ),
                  24.heightBox,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
