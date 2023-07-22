import 'package:hyaw_mahider/services/api-service.dart';
import 'package:hyaw_mahider/theme/app_theme.dart';
import 'package:hyaw_mahider/theme/constant.dart';

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hyaw_mahider/models/NoticeBoard.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import './components/file_view.dart';
import 'package:timeago/timeago.dart' as timeago;

class ScreensHome extends StatefulWidget {
  @override
  _ScreensHomeState createState() => _ScreensHomeState();
}

class _ScreensHomeState extends State<ScreensHome> {
  late CustomTheme customTheme;
  late ThemeData theme;
  List<NoticeBoard> noticesItems = [];
  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    getNotices();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding:
          FxSpacing.fromLTRB(20, FxSpacing.safeAreaTop(context) + 20, 20, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            notices(),
            FxSpacing.height(20),
          ],
        ),
      ),
    ));
  }

  Future<List<NoticeBoard>> fetchNotices() async {
    APIService apiService = APIService();
    List<NoticeBoard> noticeBoards = [];
    try {
      var data =
          await apiService.getData('auth/teams-module/team/announcments');

      noticeBoards = parseNoticeBoards(data);
      print('is working $noticeBoards');
    } catch (e) {
      print('something went wrong $e');
    }
    print(noticeBoards);

    return noticeBoards;
  }

  Widget notices() {
    List<Widget> list = [];

    for (int i = 0; i < noticesItems.length; i++) {
      list.add(notice(noticesItems[i]));
    }
    return Column(
      children: list,
    );
  }

  Future<void> getNotices() async {
    try {
      final data = await fetchNotices();
      setState(() {
        noticesItems = data;
      });
    } catch (error) {
      print('Error fetching attendance data: $error');
    }
  }

  String ago(String dateString) {
    final now = DateTime.now();
    final date = DateTime.parse(dateString);
    return timeago.format(date, locale: 'en');
  }

  Widget notice(NoticeBoard notice) {
    bool _isDownloading = false;
    AnimationController _animationController;
    IconData _currentIcon = Icons.pause_circle;

    return FxContainer(
      onTap: () {
        // controller.goToSingleCarScreen(car);
      },
      margin: FxSpacing.bottom(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FxText.bodyLarge(
            notice.title,
            fontWeight: 700,
          ),
          FxSpacing.height(4),
          Row(
            children: [
              Icon(
                FeatherIcons.user,
                size: 12,
              ),
              FxSpacing.width(4),
              FxText.bodySmall(
                notice.author,
                xMuted: true,
              ),
            ],
          ),
          FxSpacing.height(20),
          FxContainer(
            paddingAll: 0,
            borderRadiusAll: Constant.containerRadius.xs,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: FxText.bodyMedium(
              notice.content,
              xMuted: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [FileViewer()]),
          ),
          FxSpacing.height(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon(
                  //   Icons.person,
                  //   color: theme.colorScheme.primary,
                  //   size: 20,
                  // ),
                  FxSpacing.width(4),
                  // FxText.bodySmall(
                  //   "warning",
                  //   fontWeight: 600,
                  // ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon(
                  //   Icons.settings,
                  //   color: theme.colorScheme.primary,
                  //   size: 20,
                  // ),
                  FxSpacing.width(4),
                  FxText.bodySmall(
                    '',
                    fontWeight: 600,
                  ),
                ],
              ),
              FxText.bodySmall(ago(notice.createdAt)),
            ],
          ),
        ],
      ),
    );
  }
}

List<NoticeBoard> parseNoticeBoards(String data) {
  List<dynamic> decodedData = json.decode(data)['data'];
  List<NoticeBoard> noticeBoards =
      decodedData.map((item) => NoticeBoard.fromMap(item)).toList();
  return noticeBoards;
}
