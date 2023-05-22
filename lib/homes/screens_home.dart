import 'package:hyaw_mahider/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:provider/provider.dart';

import '../theme/app_notifier.dart';
import 'single_grid_item.dart';

class ScreensHome extends StatefulWidget {
  @override
  _ScreensHomeState createState() => _ScreensHomeState();
}

class _ScreensHomeState extends State<ScreensHome> {
  late CustomTheme customTheme;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (BuildContext context, AppNotifier value, Widget? child) {
        return ListView(
          padding: FxSpacing.x(20),
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: <Widget>[
            FxText.titleSmall(
              "APPS",
              fontWeight: 700,
              muted: true,
            ),
          ],
        );
      },
    );
  }
}
