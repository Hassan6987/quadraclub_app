// create_password_screen.dart

import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/authentication/ui/create_account_screen.dart';
import 'package:quadraclub_app/presentation/authentication/ui/widgets/auth_appbar.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';
import 'package:quadraclub_app/utils/const/dimensions_resource.dart';

import '../bloc/auth_bloc.dart';

class CreatePasswordScreen extends StatefulWidget {
  final String email;

  const CreatePasswordScreen({super.key, required this.email});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updateButtonState);
    _confirmPasswordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_updateButtonState);
    _confirmPasswordController.removeListener(_updateButtonState);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final isMatch =
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword;
    if (_isButtonEnabled != isMatch) {
      setState(() {
        _isButtonEnabled = isMatch;
      });
    }
  }

  void _onContinue() {
    if (_isButtonEnabled) {
      if (_formKey.currentState!.validate()) {
        context.read<AuthBloc>().add(
          SetPassword(
            email: widget.email,
            password: _passwordController.text,
            role: 'COACH',
          ),
        );
      }
    }
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStateStatus.success) {
          context.showToast("Signup Completed .Please complete your profile");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => CreateAccountScreen()),
            (route) => false,
          );
        } else if (state.status == AuthStateStatus.failure) {
          context.showToast(
            state.error ?? 'Something went wrong',
            isError: true,
          );
        }
      },
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AuthAppBar(showBackButton: false),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dim.PADDING_SIZE_LARGE,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create Password",
                  style: AppStyles.headingSemibold.copyWith(color: kBlackColor),
                ),
                8.heightBox,
                Text(
                  "Create a Password to Secure Your Account.",
                  style: AppStyles.subtitleRegular.copyWith(color: kTextColor),
                ),
                32.heightBox,
                CustomTextField(
                  label: "Password",
                  controller: _passwordController,
                  hintText: "Enter your password",
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  validator: ValidateForm.passwordValidator,
                  onChanged: (_) => _updateButtonState(),
                ),
                20.heightBox,
                CustomTextField(
                  label: "Confirm Password",
                  controller: _confirmPasswordController,
                  hintText: "Confirm your password",
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  validator: _confirmPasswordValidator,
                  onChanged: (_) => _updateButtonState(),
                ),
                40.heightBox,
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state.status == AuthStateStatus.loading) {
                      return Center(child: CustomLoadingView());
                    }
                    return CustomActionButton(
                      buttonText: "Continue",
                      onTap: _onContinue,
                      isEnabled: _isButtonEnabled,
                      backgroundColor: const Color(0xFFC79B26),
                      buttonTextColor: kWhiteColor,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
