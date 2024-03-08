import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:x_hub/other/extensions.dart';
import '../models/setting_connected_account_response_model.dart';
import '../services/api.dart';

class SettingConnectedAccountProvider extends ChangeNotifier {
  var connectedAccounts = <ConnectedAccount>[];
  bool isLoader = false;
  bool submit = false;
  int? selectedOption = 1;

  Future<void> getConnected() async {
    Api.getConnected().then((response) {
      if (response.settingConnectedAccountResponse != null) {
        connectedAccounts = response.settingConnectedAccountResponse!.data!;
      }

      isLoader = true;
      notifyListeners();
    });
  }

  Future<void> addConnected() async {
    submit = true;

    Api.addConnected(selectedOption == 1 ? 'allegro' : 'olx').then((response) {
      if (response.success ?? false) {
        submit = false;
        getConnected();
      }
    });
  }

  Future<void> deleteConnected(int id) async {
    Api.deleteConnected(id).then((response) {
      if (response.success ?? false) {
        getConnected();
      }
    });
  }

  void resetParams() {
    connectedAccounts = <ConnectedAccount>[];
    isLoader = false;
    submit = false;
    selectedOption = 1;
  }

  void setSelected(int val) {
    selectedOption = val;
    notifyListeners();
  }

  void setSubmit(bool val) {
    submit = val;
    notifyListeners();
  }

  void openWeb(String url) async {
    PlatformWebViewControllerCreationParams? params;
    WebViewController webController;
    WebViewCookieManager cookieManager = WebViewCookieManager();

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    webController = WebViewController.fromPlatformCreationParams(params);

    webController.clearLocalStorage();
    webController.clearCache();

    webController
      ..clearCache()
      ..clearLocalStorage()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            } else if (request.url.contains('connectors/oauth/result?success=')) {
              final str = Uri.parse(request.url);

              if (str.queryParameters['success'] != null) {
                Get.back();

                if (str.queryParameters['message'] != null) {
                  snackBar(text: str.queryParameters['message']!, error: true);
                } else {
                  getConnected();
                }
              }

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onPageFinished: (e) async {
            await cookieManager.clearCookies();
            webController.clearLocalStorage();
            webController.clearCache();
          }
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          snackBar(text: message.message);
        },
      )
      ..loadRequest(Uri.parse(url), headers: {});

    if (webController.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (webController.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }

    await cookieManager.clearCookies();

    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.white,
      elevation: 10,
      useSafeArea: true,
      enableDrag: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        height: 2.0,
                        width: 20.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Expanded(
                        child: WebViewWidget(controller: webController)
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> openWebBool(String url) async {
    PlatformWebViewControllerCreationParams? params;
    WebViewController webController;
    WebViewCookieManager cookieManager = WebViewCookieManager();

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    webController = WebViewController.fromPlatformCreationParams(params);

    webController.clearLocalStorage();
    webController.clearCache();

    webController
      ..clearCache()
      ..clearLocalStorage()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              } else if (request.url.contains('connectors/oauth/result?success=')) {
                final str = Uri.parse(request.url);

                if (str.queryParameters['success'] != null) {
                  Get.back();

                  if (str.queryParameters['message'] != null) {
                    snackBar(text: str.queryParameters['message']!, error: true);
                  } else {
                    getConnected();
                  }
                }

                return NavigationDecision.prevent;
              }

              return NavigationDecision.navigate;
            },
            onPageFinished: (e) async {
              await cookieManager.clearCookies();
              webController.clearLocalStorage();
              webController.clearCache();
            }
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          snackBar(text: message.message);
        },
      )
      ..loadRequest(Uri.parse(url), headers: {});

    if (webController.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (webController.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }

    await cookieManager.clearCookies();

    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.white,
      elevation: 10,
      useSafeArea: true,
      enableDrag: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        height: 2.0,
                        width: 20.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Expanded(
                      child: WebViewWidget(controller: webController)
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    return true;
  }
}