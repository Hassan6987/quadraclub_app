import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/authentication/ui/otp_verifictaion.dart';
import 'package:quadraclub_app/presentation/authentication/ui/widgets/auth_appbar.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';
import 'package:quadraclub_app/utils/const/dimensions_resource.dart';

import '/app_exports.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    _emailController.addListener(_updateButtonState);
    super.initState();
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
        context.read<AuthBloc>().add(ForgotPassword(email: email));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(title: ""),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStateStatus.failure) {
            context.showToast(
              state.error ?? 'something is wrong',
              isError: true,
            );
          } else if (state.status == AuthStateStatus.otpSent) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OtpVerificationScreen(
                  email: _emailController.text,
                  isReset: true,
                ),
              ),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dim.PADDING_SIZE_LARGE),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.heightBox,
                Text(
                  "Forgot Password",
                  style: AppStyles.headingSemibold.copyWith(color: kBlackColor),
                ),
                8.heightBox,
                Text(
                  "Reset Password OTP will be sent to your email",
                  style: AppStyles.subtitleRegular.copyWith(color: kTextColor),
                ),
                10.heightBox,
                CustomTextField(
                  hintText: "Enter your email",
                  controller: _emailController,
                  keyboardType: TextInputType.text,
                  validator: ValidateForm.validateEmail,
                  label: 'Email',
                ),
                40.heightBox,
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state.status == AuthStateStatus.loading) {
                      return Center(child: CustomLoadingView());
                    }
                    return CustomActionButton(
                      buttonText: "Send Reset Link",
                      onTap: _onContinue,
                      isEnabled: _isButtonEnabled,
                      backgroundColor: kSecondaryColor,
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
