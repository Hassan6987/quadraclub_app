// signup_screen.dart

import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';
import 'package:quadraclub_app/utils/const/dimensions_resource.dart';

import 'otp_verifictaion.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateButtonState);
    _emailController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _emailController.text.trim().isNotEmpty;
    });
  }

  void _onContinue() {
    if (_isButtonEnabled) {
      if (_formKey.currentState!.validate()) {
        final email = _emailController.text.trim();
        context.read<AuthBloc>().add(RequestCode(email: email));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      resizeToAvoidBottomInset: false,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStateStatus.failure) {
            context.showToast(
              state.error ?? 'something is wrong',
              isError: true,
            );
          } else if (state.status == AuthStateStatus.success) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    OtpVerificationScreen(email: _emailController.text),
              ),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dim.PADDING_SIZE_LARGE),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                100.heightBox,
                Text(
                  "Sign Up",
                  style: AppStyles.headingSemibold.copyWith(color: kBlackColor),
                ),
                8.heightBox,
                Text(
                  "Enter your details to get started.",
                  style: AppStyles.subtitleRegular.copyWith(color: kTextColor),
                ),
                32.heightBox,
                CustomTextField(
                  label: "Email",
                  controller: _emailController,
                  hintText: "Enter your email",
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidateForm.validateCoachEmail,
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
                const Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: AppStyles.titleRegular.copyWith(
                            color: kBlackColor,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              RouteName.signIn,
                            );
                          },
                          child: Text(
                            "Sign in",
                            style: AppStyles.titleSemibold.copyWith(
                              color: kSecondaryColor,
                              decoration: TextDecoration.underline,
                              decorationColor: kSecondaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
