import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ithraashop/constants.dart';
import 'package:ithraashop/pages/privacy_page.dart';
import 'package:ithraashop/pages/terms_page.dart';
import 'package:ithraashop/widgets/circular_image.dart';
import 'package:ithraashop/widgets/zoom_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';

class MenuPage extends StatefulWidget {
  final RateMyApp rateMyApp;
  const MenuPage({Key? key, required this.rateMyApp}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late List<MenuItem> options;

  @override
  void initState() {
    options = [
      MenuItem(
        icon: Icons.privacy_tip_outlined,
        title: 'privacyPolicy'.tr,
        onPress: (context) => Get.to(
          () => const PrivacyPage(),
          transition: Transition.circularReveal,
          duration: const Duration(milliseconds: 650),
        ),
      ),
      MenuItem(
        icon: Icons.line_style_rounded,
        title: 'termsConditions'.tr,
        onPress: (context) => Get.to(
          () => const TermsPage(),
          transition: Transition.circularReveal,
          duration: const Duration(milliseconds: 650),
        ),
      ),
      MenuItem(
          icon: Icons.share_outlined,
          title: 'share'.tr,
          onPress: (context) async {
            final box = context.findRenderObject() as RenderBox?;

            await Share.share(
              'checkThisWebiste'.tr + ' $siteURL',
              sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
            );
          }),
      MenuItem(
          icon: Icons.star_rate_outlined,
          title: 'rateUs'.tr,
          onPress: (context) {
            widget.rateMyApp.showStarRateDialog(context,
                title: 'rateThisApp'.tr,
                message: 'rateThisAppMessage'.tr,
                starRatingOptions: const StarRatingOptions(initialRating: 4),
                actionsBuilder: actionBuilder);
          }),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        //on swiping left
        if (details.delta.dx < -6) {
          Provider.of<MenuController>(context, listen: false).toggle();
        }
      },
      child: GestureDetector(
        onTap: () => Provider.of<MenuController>(context, listen: false).toggle(),
        child: Container(
          padding: EdgeInsets.only(top: 62, left: 32, bottom: 8, right: MediaQuery.of(context).size.width / 2.9),
          color: Theme.of(context).primaryColorDark, //const Color(0xff454dff),
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: Get.locale!.languageCode == 'ar' ? const EdgeInsets.only(left: 16) : const EdgeInsets.only(right: 16),
                    child: const CircularImage(
                      AssetImage('assets/images/logo.png'),
                    ),
                  ),
                  const Text(
                    'Weebee',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: options.map((item) {
                  return Ink(
                    child: ListTile(
                      onTap: () {
                        item.onPress(context);
                      },
                      leading: Icon(
                        item.icon,
                        color: Colors.white,
                        size: 20,
                      ),
                      title: Text(
                        item.title,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> actionBuilder(BuildContext context, double? stars) {
    return stars == null ? [buildCancelButton()] : [buildOkButton(), buildCancelButton()];
  }

  Widget buildOkButton() {
    return RateMyAppRateButton(widget.rateMyApp, text: 'ok'.tr);
  }

  Widget buildCancelButton() {
    return RateMyAppNoButton(widget.rateMyApp, text: 'no'.tr);
  }
}

class MenuItem {
  String title;
  IconData icon;
  Function(BuildContext context) onPress;

  MenuItem({required this.icon, required this.title, required this.onPress});
}
