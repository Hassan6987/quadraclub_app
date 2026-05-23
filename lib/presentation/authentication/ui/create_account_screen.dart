import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/authentication/ui/widgets/auth_appbar.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _collegeController = TextEditingController();
  final TextEditingController _linkOneController = TextEditingController();
  final TextEditingController _linkTwoController = TextEditingController();
  final TextEditingController _linkThreeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool get _isButtonEnabled {
    return _fullNameController.text.isNotEmpty &&
        _collegeController.text.isNotEmpty;
  }

  void _onContinue() {
    if (_isButtonEnabled) {
      if (_formKey.currentState!.validate()) {
        context.read<AuthBloc>().add(
          SetupProfile(
            name: _fullNameController.text,
            college: _collegeController.text,
            linkOne: _linkOneController.text,
            linkTwo: _linkTwoController.text,
            linkThree: _linkThreeController.text,
          ),
        );
      }
      debugPrint("Continue -> Save profile setup");
      debugPrint("Name: ${_fullNameController.text}");
      debugPrint("Team: ${_collegeController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: const AuthAppBar(),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStateStatus.failure) {
            context.showToast(
              state.error ?? "something went wrong",
              isError: true,
            );
          } else if (state.status == AuthStateStatus.success) {
            context.showToast("Profile Created Successfully");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => CustomBottomNavBar()),
              (route) => false,
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profile Setup",
                  style: AppStyles.headingSemibold.copyWith(color: kBlackColor),
                ),
                4.heightBox,
                Text(
                  "Setup your profile to continue.",
                  style: AppStyles.subtitleRegular.copyWith(color: kTextColor),
                ),
                24.heightBox,
                CustomTextField(
                  label: "Full Name",
                  controller: _fullNameController,
                  hintText: "Enter your name",
                  validator: ValidateForm.fullNameValidator,
                  onChanged: (_) => setState(() {}),
                ),
                16.heightBox,
                CustomTextField(
                  label: "College Name",
                  controller: _collegeController,
                  hintText: "Enter your college name",
                  validator: ValidateForm.validateCollege,
                  onChanged: (_) => setState(() {}),
                ),
                16.heightBox,
                CustomTextField(
                  label: "Link 1",
                  controller: _linkOneController,
                  hintText: "Enter any url link about you",
                  validator: ValidateForm.validateLink,
                  onChanged: (_) => setState(() {}),
                ),
                16.heightBox,
                CustomTextField(
                  label: "Link 2",
                  controller: _linkTwoController,
                  hintText: "Enter any url link about you",
                  validator: ValidateForm.validateLink,
                  onChanged: (_) => setState(() {}),
                ),
                16.heightBox,
                CustomTextField(
                  label: "Link 3",
                  controller: _linkThreeController,
                  hintText: "Enter any url link about you",
                  validator: ValidateForm.validateLink,
                  onChanged: (_) => setState(() {}),
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
                      width: double.infinity,
                    );
                  },
                ),
                20.heightBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
