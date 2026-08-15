import 'package:quadraclub_app/data/storage_service.dart';

import '/app_exports.dart';
import 'data/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onNext() {
    if (_currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _goToWelcome();
    }
  }

  void _goToWelcome() {
    StorageService().saveOnboarding();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: PageView.builder(
        controller: _pageController,
        itemCount: onboardingPages.length,
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
        itemBuilder: (context, index) {
          final page = onboardingPages[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 6,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(page.image, fit: BoxFit.fill),
                    Container(
                      color: const Color(0x99000000), // ✅ #00000033 overlay
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              width: 300,
                              height: 150,
                              alignment: Alignment.center,
                              child: Image.asset(
                                Assets.png.splashLogo.path,
                                fit: BoxFit.contain,
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(
                            page.title,
                            style: AppStyles.w600f24inter.copyWith(
                              color: kPrimaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          12.heightBox,
                          Text(
                            page.subtitle,
                            style: AppStyles.w400f16inter.copyWith(
                              fontSize: 16,
                              color: kWhiteColor,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          24.heightBox,

                          /// ✅ Using CustomActionButton here
                          CustomActionButton(
                            buttonText: "Continue",
                            onTap: _onNext,
                            backgroundColor: kPrimaryColor,
                            buttonTextStyle: AppStyles.titleMedium.copyWith(
                              color: kBlackColor,
                            ),
                          ),

                          24.heightBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              onboardingPages.length,
                              (index) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                ),
                                child: Container(
                                  width: _currentPage == index ? 24 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: _currentPage == index
                                        ? kPrimaryColor
                                        : kWhiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
