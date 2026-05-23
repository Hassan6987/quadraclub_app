import 'package:flutter/foundation.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/utils/components/blue_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  late WebViewController _webViewCtrl;
  bool showLoading = true;
  int loaderValue = 0;

  @override
  void initState() {
    super.initState();
    _webViewCtrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
        'Mozilla/5.0 (Linux; Android 11; Pixel 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.91 Mobile Safari/537.36',
      )
      ..loadRequest(
        Uri.parse('https://thesoftballnation.com/terms-conditions/'),
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) async {
            setState(() {
              loaderValue = progress;
            });
            if (progress == 100) {
              await Future.delayed(const Duration(milliseconds: 300), () {
                setState(() {
                  showLoading = false;
                });

                _webViewCtrl.runJavaScript('''
              document.getElementsByTagName('header')[0].style.display='none';
              document.querySelector('.navigation-drawer').style.display='none';
            ''');
              });
            }
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BlueAppBar(
        title: 'Terms & Conditions',
        showBackArrow: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // WebView
            Expanded(
              child: showLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              appLoadingAnimation(),
                              Text(
                                '$loaderValue%',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Stack(
                      children: [
                        WebViewWidget(
                          gestureRecognizers:
                              <Factory<OneSequenceGestureRecognizer>>{
                                Factory<VerticalDragGestureRecognizer>(
                                  () => VerticalDragGestureRecognizer(),
                                ),
                              },
                          controller: _webViewCtrl,
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appLoadingAnimation() {
    return Center(
      child: LoadingAnimationWidget.discreteCircle(
        color: kPrimaryColor,
        size: 40,
      ),
    );
  }
}
