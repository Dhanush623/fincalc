import 'package:finance/src/helper/analytics_helper.dart';
import 'package:finance/src/utils/constants.dart';
import 'package:finance/src/widgets/my_banner_ad.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsAndConditions extends StatelessWidget {
  TermsAndConditions({super.key});
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    // ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
          addScreenViewTracking(
            "Webview",
            "TermsAndConditions",
          );
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(Constants.fincalcPrivacyPolicy));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Constants.termsConditions,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: WebViewWidget(
              controller: controller,
            ),
          ),
          SizedBox(
            width: AdSize.banner.width.toDouble(),
            height: AdSize.banner.height.toDouble(),
            child: const MyBannerAdWidget(),
          ),
        ],
      ),
    );
  }
}
