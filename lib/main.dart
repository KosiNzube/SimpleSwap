import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'Darkmode/DarkThemeProvider.dart';
import 'Screens/review_swap_screen.dart';
import 'helpers/routes.dart';
import 'Styles/Styles.dart';

import 'package:meta_seo/meta_seo.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setPathUrlStrategy();

  if (kIsWeb) MetaSEO();



    runApp(MyApp());
  }



class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }


  @override
  Widget build(BuildContext context) {
  //  FlutterNativeSplash.remove();


    return
      ChangeNotifierProvider(
        create: (_) {
          return themeChangeProvider;
        },
        child: Consumer<DarkThemeProvider>(
          builder: (BuildContext context, value, Widget? child) {
            return MaterialApp(
              shortcuts: {
                LogicalKeySet(LogicalKeyboardKey.space):ActivateIntent(),
              },
              navigatorObservers: [FlutterSmartDialog.observer],
              // here
              builder: FlutterSmartDialog.init(),
              debugShowCheckedModeBanner: false,
              theme: Styles.themeData(themeChangeProvider.darkTheme, context),
              initialRoute: Routes.home,
              onGenerateRoute: (RouteSettings settings) {
                return Routes.fadeThrough(settings, (context) {

                  if (settings.name ==Routes.home) {
                    return Review_Swap_Screen();
                  }


                  return Center(child: CircularProgressIndicator());
                });
              },
            );
          },
        ),);
  }
}



























void snack(String s, BuildContext context) {

  SmartDialog.showToast(s,displayTime: Duration(seconds: 1),alignment:Alignment.center );



}

void snacklong(String s) {

  SmartDialog.showToast(s,displayTime: Duration(seconds: 7),alignment:Alignment.bottomCenter );



}

void snackINS( BuildContext context) {
  SmartDialog.showToast("Only PREMIUM members can make this request",displayTime: Duration(seconds: 3),alignment:Alignment.center );


}


void snackxxx(String s, BuildContext context) {

  SmartDialog.showToast(s,alignment:Alignment.center );


}
void snacklen(String s, BuildContext context) {

  SmartDialog.showToast(s,displayTime: Duration(seconds: 2),alignment:Alignment.center );


}

void snacklenx(String s, BuildContext context) {

  SmartDialog.showToast(s,displayTime: Duration(seconds: 5),alignment:Alignment.center );


}


