import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ithraashop/constants.dart';
import 'package:ithraashop/pages/menu_page.dart';
import 'package:ithraashop/notification_service.dart';
import 'package:ithraashop/widgets/logo_progress.dart';
import 'package:ithraashop/widgets/zoom_scaffold.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  final RateMyApp? rateMyApp;

  const HomePage({Key? key, this.rateMyApp}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final WebViewController _controller;
  late MenuController menuController;
  double percent = 0.0;

  bool _isVisibleProgress = true;
  bool _offstage = true;
  String _authStatus = 'Unknown';
  var formdata = <String, dynamic>{};
  late NotifyHelper notifyHelper;

  Future<bool> _willPopCallback() async {
    bool goBack = false;
    bool canNavigate = await _controller.canGoBack();

    if (canNavigate) {
      _controller.goBack();
      return false;
    } else {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'confirmation'.tr,
            style: const TextStyle(color: Colors.purple),
            textAlign: Get.locale!.languageCode == 'ar' ? TextAlign.right : TextAlign.left,
          ),
          // Are you sure?
          content: Text('exitapp'.tr, textAlign: Get.locale!.languageCode == 'ar' ? TextAlign.right : TextAlign.left),
          // Do you want to go back?
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // SystemNavigator.pop();
                Navigator.of(context).pop();

                setState(() {
                  goBack = false;
                });
              },
              child: Text("no".tr, textAlign: TextAlign.center), // No
            ),
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop();
                // Navigator.of(context, rootNavigator: true).maybePop(false);
                SystemNavigator.pop();
                setState(() {
                  goBack = true;
                });
              },
              child: Text(
                "yes".tr,
                textAlign: TextAlign.center,
              ), // Yes
            ),
          ],
        ),
      );

      if (goBack) Navigator.pop(context); // If user press Yes pop the page
      return goBack;
    }
  }

  @override
  void initState() {
    super.initState();
    menuController = MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));

    notifyHelper = NotifyHelper(context);
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();

    WidgetsBinding.instance.addPostFrameCallback((_) => initPlugin());
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance.getToken().then((value) async {
      formdata['di'] = value;
      formdata['device'] = Platform.isIOS ? "iPhone" : "Android";
      formdata['auth'] = postURLAuthKey;

      // http.Response resp = await http.post(Uri.parse(firebasePostURL), body: formdata, headers: {
      //   HttpHeaders.authorizationHeader: postURLAuthKey,
      // });
    });

    firebaseOnMessage();
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  void onFirebaseOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {});
  }

  void firebaseOnMessage() {
    FirebaseMessaging.onMessage.listen((event) {
      try {
        final title = event.notification!.title;
        final body = event.notification!.body;
        notifyHelper.displayNotification(title: title!, body: body!);
      } catch (e) {
        print(e);
      }
    });
  }

  Future<void> initPlugin() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
      setState(() => _authStatus = '$status');
      // If the system can show an authorization request dialog
      if (status == TrackingStatus.notDetermined) {
        final TrackingStatus status = await AppTrackingTransparency.requestTrackingAuthorization();
        setState(() => _authStatus = '$status');
      }
    } on PlatformException {
      setState(() => _authStatus = 'PlatformException was thrown');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Theme.of(context).colorScheme.primary));

    return ChangeNotifierProvider(
      create: (BuildContext context) => menuController,
      child: SafeArea(
        child: ZoomScaffold(
          menuScreen: MenuPage(
            rateMyApp: widget.rateMyApp!,
          ),
          contentScreen: Layout(
            contentBuilder: (cc) => WillPopScope(
              onWillPop: _willPopCallback,
              child: Container(
                color: splashBackgroundColor,
                child: Center(
                  child: Stack(
                    children: [
                      Offstage(
                        offstage: _offstage,
                        // maintainState: true,
                        child: WebView(
                          initialUrl: siteURL,
                          zoomEnabled: false,
                          gestureNavigationEnabled: true,
                          allowsInlineMediaPlayback: true,
                          initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated: (WebViewController webViewController) {
                            _controller = webViewController;

                            _controller.runJavascript(
                                "window.document.body.style.overflow = 'hidden'; var els =document.getElementsByClassName('site-logo-container');for(var i=0, len=els.length; i<len; i++){els[i].style['height'] = '50px';}");
                          },
                          onProgress: (int progress) {
                            setState(() {
                              percent = progress.toDouble() / 100;
                            });
                          },
                          navigationDelegate: (NavigationRequest request) async {
                            if (request.url.startsWith('https://api.whatsapp.com/send')) {
                              List<String> urlSplitted = request.url.split("&text=");

                              String start = 'phone=';
                              String end = '&';
                              final startIndex = request.url.indexOf(start);
                              final endIndex = request.url.indexOf(end);
                              String phone = request.url.substring(startIndex + start.length, endIndex).trim(); //"966556111975";

                              String message = urlSplitted.last.toString().replaceAll("%20", " ");

                              await _launchURL("https://wa.me/$phone/?text=${Uri.parse(message)}");
                              return NavigationDecision.prevent;
                            }

                            if (request.url.startsWith('https://vt.tiktok.com')) {
                              await _launchURL(request.url);
                              return NavigationDecision.prevent;
                            }

                            setState(() {
                              _isVisibleProgress = true;
                            });
                            return NavigationDecision.navigate;
                          },
                          onPageStarted: (String url) {
                            setState(() {
                              _isVisibleProgress = true;
                            });
                          },
                          onPageFinished: (String url) {
                            setState(() {
                              _offstage = false;
                              _isVisibleProgress = false;
                            });
                          },
                          onWebResourceError: (WebResourceError error) async {
                            String fileText = await rootBundle.loadString('assets/web/404.html');
                            _controller
                                .loadUrl(Uri.dataFromString(fileText, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
                          },
                        ),
                      ),
                      Center(
                        child: Visibility(
                          visible: _isVisibleProgress,
                          child: _buildLogoPorgress(), //_buildProgress(context), //,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  Widget _buildLogoPorgress() {
    return useLogoLoader
        ? LogoProgress(percent: percent)
        : (useCircularLoader
            ? SizedBox(
                height: Get.mediaQuery.size.width * 0.2,
                width: Get.mediaQuery.size.width * 0.2,
                child: LiquidCircularProgressIndicator(
                  value: percent, // Defaults to 0.5.
                  backgroundColor: progressColor, // Defaults to the current Theme's backgroundColor.
                  direction: Axis
                      .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                  center: Text(
                    (percent * 100).toString() + "%",
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: progressColor,
                    ),
                  ),
                ),
              )
            : Container(
                height: 30.0,
                padding: EdgeInsets.symmetric(horizontal: Get.mediaQuery.size.width * 0.1),
                child: LiquidLinearProgressIndicator(
                  value: percent, // Defaults to 0.5.
                  backgroundColor: progressColor, // Defaults to the current Theme's backgroundColor.
                  borderRadius: 12.0,
                  direction: Axis
                      .horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                  center: Text(
                    (percent * 100).toString() + "%",
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: progressColor,
                    ),
                  ),
                ),
              ));
  }
}
