/*
* File : Main File
* We are using our own package (FlutX) : https://pub.dev/packages/flutx
* Version : 13
* */

import 'package:hyaw_mahider/guard/auth-guard.dart';
import 'package:hyaw_mahider/homes/homes_screen.dart';
import 'package:hyaw_mahider/localizations/app_localization_delegate.dart';
import 'package:hyaw_mahider/localizations/language.dart';
import 'package:hyaw_mahider/theme/app_notifier.dart';
import 'package:hyaw_mahider/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  //You will need to initialize AppThemeNotifier class for theme changes.
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  AppTheme.init();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(ChangeNotifierProvider<AppNotifier>(
    create: (context) => AppNotifier(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (BuildContext context, AppNotifier value, Widget? child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.theme,
            builder: (context, child) {
              return Directionality(
                textDirection: AppTheme.textDirection,
                child: child!,
              );
            },
            localizationsDelegates: [
              AppLocalizationsDelegate(context),
              // Add this line
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: Language.getLocales(),
            // home: IntroScreen(),
            // home: SplashScreen(),
            // home: HomesScreen(),
            home: AuthGuard(child: HomesScreen()));
      },
    );
  }
}
