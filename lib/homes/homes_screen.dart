import 'package:hyaw_mahider/extensions/extensions.dart';
// import 'package:hyaw_mahider/homes/animations_home.dart';
import 'package:hyaw_mahider/homes/select_language_dialog.dart';
import 'package:hyaw_mahider/images.dart';
import 'package:hyaw_mahider/theme/app_notifier.dart';
import 'package:hyaw_mahider/theme/app_theme.dart';
import 'package:hyaw_mahider/theme/theme_type.dart';
import 'package:hyaw_mahider/widgets/custom/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hyaw_mahider/Attendance/index.dart';
import 'app_setting_screen.dart';
// import 'custom_apps_home.dart';

import 'screens_home.dart';

class HomesScreen extends StatefulWidget {
  HomesScreen({Key? key}) : super(key: key);

  @override
  _HomesScreenState createState() => _HomesScreenState();
}

class _HomesScreenState extends State<HomesScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 1;

  late ThemeData theme;
  late CustomTheme customTheme;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  late TabController tabController;
  late List<NavItem> navItems;

  bool isDark = false;
  TextDirection textDirection = TextDirection.ltr;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 5, vsync: this, initialIndex: 1);

    navItems = [
      NavItem('Attendance', Images.animationDesignIcon, AttendanceViewScreen()),
      NavItem('Home', Images.app2Icon, ScreensHome()),
      // NavItem('Material Widgets', Images.materialDesignIcon,
      //     MaterialWidgetsHome(), 32),
      // NavItem('Other Widgets', Images.otherDesignIcon, OthersHome()),
    ];

    tabController.addListener(() {
      currentIndex = tabController.index;
      setState(() {});
    });

    tabController.animation!.addListener(() {
      final aniValue = tabController.animation!.value;
      if (aniValue - currentIndex > 0.5) {
        currentIndex++;
      } else if (aniValue - currentIndex < -0.5) {
        currentIndex--;
      }

      setState(() {});
    });
  }

  void changeDirection() {
    if (AppTheme.textDirection == TextDirection.ltr) {
      Provider.of<AppNotifier>(context, listen: false)
          .changeDirectionality(TextDirection.rtl);
    } else {
      Provider.of<AppNotifier>(context, listen: false)
          .changeDirectionality(TextDirection.ltr);
    }
    setState(() {});
  }

  void changeTheme() {
    if (AppTheme.themeType == ThemeType.light) {
      Provider.of<AppNotifier>(context, listen: false)
          .updateTheme(ThemeType.dark);
    } else {
      Provider.of<AppNotifier>(context, listen: false)
          .updateTheme(ThemeType.light);
    }
    setState(() {});
  }

  void launchCodecanyonURL() async {
    String url =
        "https://codecanyon.net/item/hyaw_mahider-flutter-ui-kit/27510289";
    await launchUrl(Uri.parse(url));
  }

  void launchDocumentation() async {
    String url = "https://hyaw_mahider.coderthemes.com/index.html";
    await launchUrl(Uri.parse(url));
  }

  void launchChangeLog() async {
    String url = "https://hyaw_mahider.coderthemes.com/changelogs.html";
    await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (BuildContext context, AppNotifier value, Widget? child) {
        isDark = AppTheme.themeType == ThemeType.dark;
        textDirection = AppTheme.textDirection;
        theme = AppTheme.theme;
        customTheme = AppTheme.customTheme;
        return Scaffold(
          key: _drawerKey,
          appBar: AppBar(
            elevation: 0,
            title: FxText.titleMedium(
              navItems[currentIndex].title,
              fontWeight: 600,
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AppSettingScreen()));
                },
                child: Container(
                  padding: FxSpacing.x(20),
                  child: Image(
                    image: AssetImage(Images.settingIcon),
                    color: theme.colorScheme.onBackground,
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                    controller: tabController,
                    children:
                        navItems.map((navItem) => navItem.screen).toList()),
              ),
              FxContainer.none(
                padding: FxSpacing.xy(12, 16),
                color: theme.scaffoldBackgroundColor,
                bordered: true,
                enableBorderRadius: false,
                borderRadiusAll: 0,
                border: Border(
                  top: BorderSide(width: 2, color: customTheme.border),
                ),
                child: TabBar(
                  controller: tabController,
                  indicator: FxTabIndicator(
                      indicatorColor: theme.colorScheme.primary,
                      indicatorStyle: FxTabIndicatorStyle.rectangle,
                      indicatorHeight: 2,
                      radius: 4,
                      yOffset: -18,
                      width: 20),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: theme.colorScheme.primary,
                  tabs: buildTab(),
                ),
              )
            ],
          ),
          drawer: _buildDrawer(),
        );
      },
    );
  }

  Widget _buildDrawer() {
    return FxContainer.none(
      margin:
          FxSpacing.fromLTRB(16, FxSpacing.safeAreaTop(context) + 16, 16, 16),
      borderRadiusAll: 4,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: theme.scaffoldBackgroundColor,
      child: Drawer(
          child: Container(
        color: theme.scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: FxSpacing.only(left: 20, bottom: 0, top: 24, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage(Images.brandLogo),
                    height: 102,
                    width: 102,
                  ),
                  FxSpacing.height(16),
                  FxContainer(
                    padding: FxSpacing.fromLTRB(12, 4, 12, 4),
                    borderRadiusAll: 4,
                    color: theme.colorScheme.primary.withAlpha(40),
                    child: FxText.bodyMedium("13.0",
                        color: theme.colorScheme.primary,
                        fontWeight: 600,
                        letterSpacing: 0.2),
                  ),
                  FxSpacing.height(16),
                  FxText.bodyMedium("Flutter 3.7.0 (Latest)",
                      fontWeight: 600, letterSpacing: 0.2),
                ],
              ),
            ),
            FxSpacing.height(32),
            Container(
              margin: FxSpacing.x(20),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      changeTheme();
                    },
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Row(
                      children: [
                        FxContainer(
                          paddingAll: 12,
                          borderRadiusAll: 4,
                          color: CustomTheme.occur.withAlpha(20),
                          child: Image(
                            height: 20,
                            width: 20,
                            image: AssetImage(!isDark
                                ? Images.darkModeOutline
                                : Images.lightModeOutline),
                            color: CustomTheme.occur,
                          ),
                        ),
                        FxSpacing.width(16),
                        Expanded(
                          child: FxText.bodyLarge(
                            !isDark ? 'dark_mode'.tr() : 'light_mode'.tr(),
                          ),
                        ),
                        FxSpacing.width(16),
                        Icon(
                          FeatherIcons.chevronRight,
                          size: 18,
                          color: theme.colorScheme.onBackground,
                        ).autoDirection(),
                      ],
                    ),
                  ),
                  FxSpacing.height(20),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              SelectLanguageDialog());
                    },
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Row(
                      children: [
                        FxContainer(
                          paddingAll: 12,
                          borderRadiusAll: 4,
                          color: CustomTheme.peach.withAlpha(20),
                          child: Image(
                            height: 20,
                            width: 20,
                            image: AssetImage(Images.languageOutline),
                            color: CustomTheme.peach,
                          ),
                        ),
                        FxSpacing.width(16),
                        Expanded(
                          child: FxText.bodyLarge(
                            'language'.tr(),
                          ),
                        ),
                        FxSpacing.width(16),
                        Icon(
                          FeatherIcons.chevronRight,
                          size: 18,
                          color: theme.colorScheme.onBackground,
                        ).autoDirection(),
                      ],
                    ),
                  ),
                  FxSpacing.height(20),
                  InkWell(
                    onTap: () {
                      changeDirection();
                    },
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Row(
                      children: [
                        FxContainer(
                          paddingAll: 12,
                          borderRadiusAll: 4,
                          color: CustomTheme.skyBlue.withAlpha(20),
                          child: Image(
                            height: 20,
                            width: 20,
                            image: AssetImage(
                                AppTheme.textDirection == TextDirection.ltr
                                    ? Images.paragraphRTLOutline
                                    : Images.paragraphLTROutline),
                            color: CustomTheme.skyBlue,
                          ),
                        ),
                        FxSpacing.width(16),
                        Expanded(
                          child: FxText.bodyLarge(
                            AppTheme.textDirection == TextDirection.ltr
                                ? "${'right_to_left'.tr()} (RTL)"
                                : "${'left_to_right'.tr()} (LTR)",
                          ),
                        ),
                        FxSpacing.width(16),
                        Icon(
                          FeatherIcons.chevronRight,
                          size: 18,
                          color: theme.colorScheme.onBackground,
                        ).autoDirection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            FxSpacing.height(20),
            Divider(
              thickness: 1,
            ),
            FxSpacing.height(16),
            Container(
              margin: FxSpacing.x(20),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      launchDocumentation();
                    },
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Row(
                      children: [
                        FxContainer(
                          paddingAll: 12,
                          borderRadiusAll: 4,
                          color: CustomTheme.skyBlue.withAlpha(20),
                          child: Image(
                            height: 20,
                            width: 20,
                            image: AssetImage(Images.documentationIcon),
                            color: CustomTheme.skyBlue,
                          ),
                        ),
                        FxSpacing.width(16),
                        Expanded(
                          child: FxText.bodyLarge(
                            'documentation'.tr(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FxSpacing.height(20),
                  InkWell(
                    onTap: () {
                      launchChangeLog();
                    },
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Row(
                      children: [
                        FxContainer(
                          paddingAll: 12,
                          borderRadiusAll: 4,
                          color: CustomTheme.peach.withAlpha(20),
                          child: Image(
                            height: 20,
                            width: 20,
                            image: AssetImage(Images.changeLogIcon),
                            color: CustomTheme.peach,
                          ),
                        ),
                        FxSpacing.width(16),
                        Expanded(
                          child: FxText.bodyLarge(
                            'changelog'.tr(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            FxSpacing.height(20),
            Center(
              child: FxButton(
                borderRadiusAll: 4,
                elevation: 0,
                onPressed: () {
                  launchCodecanyonURL();
                },
                splashColor: theme.colorScheme.onPrimary.withAlpha(40),
                backgroundColor: theme.colorScheme.primary,
                child: FxText(
                  'buy_now'.tr(),
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  List<Widget> buildTab() {
    List<Widget> tabs = [];

    for (int i = 0; i < navItems.length; i++) {
      tabs.add(SVG(navItems[i].icon,
          color: (currentIndex == i)
              ? theme.colorScheme.primary
              : theme.colorScheme.onBackground.withAlpha(220),
          size: navItems[i].size));
    }
    return tabs;
  }
}

class NavItem {
  final String title;
  final String icon;
  final Widget screen;
  final double size;

  NavItem(this.title, this.icon, this.screen, [this.size = 28]);
}
