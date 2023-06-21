import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import './stats/member/index.dart';
import 'dart:convert';
import 'package:hyaw_mahider/services/api-service.dart';
import './add.dart';

class AttendanceService {
  static Future<List<Map<String, dynamic>>> fetchAttendanceData() async {
    try {
      final apiService = APIService();
      final data = await apiService.getData(
          '/auth/members-module/attendance/853bcd28-df64-4826-9108-a97276ea5f40?limit=5');
      final parsedData = Map<String, dynamic>.from(jsonDecode(data));
      final attendanceData = parsedData['data'] as List<dynamic>;

      return attendanceData.cast<Map<String, dynamic>>();
    } catch (error) {
      print('Error fetching attendance data: $error');
      return []; // Return an empty list if there's an error
    }
  }
}

class AttendanceViewScreen extends StatefulWidget {
  const AttendanceViewScreen({Key? key}) : super(key: key);

  @override
  _AttendanceViewScreenState createState() => _AttendanceViewScreenState();
}

class _AttendanceViewScreenState extends State<AttendanceViewScreen> {
  List<Map<String, dynamic>> attendanceData = [];

  @override
  void initState() {
    super.initState();
    fetchAttendanceData();
  }

  Future<void> fetchAttendanceData() async {
    try {
      final data = await AttendanceService.fetchAttendanceData();
      setState(() {
        attendanceData = data;
      });
    } catch (error) {
      print('Error fetching attendance data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: FxSpacing.fromLTRB(24, 0, 24, 0),
        child: ListView.builder(
          itemCount: attendanceData.length,
          itemBuilder: (context, index) {
            final student = attendanceData[index];
            final fullName = student['full_name'];
            final attendance = List<bool>.from(student['attendance'] ?? []);

            return memberItem(
              image: './assets/images/profile/avatar_1.jpg',
              index: index,
              name: fullName,
              status: 'Status',
              attendanceData: attendance,
              context: context,
            );
          },
        ),
      ),
      floatingActionButton: SizedBox(
        width: 36,
        height: 36,
        child: FloatingActionButton(
          onPressed: _navigateToTakeAttendance,
          child: Icon(Icons.add, size: 18),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _navigateToTakeAttendance() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TakeAttendanceScreen()),
    );
  }
}

Widget memberItem({
  required String image,
  required int index,
  required String name,
  required String status,
  required List<bool> attendanceData,
  bool isActive = false,
  BuildContext? context,
}) {
  if (index >= attendanceData.length) {
    return Container(); // Return an empty container if the index is out of range
  }

  final attendance = attendanceData[index];
  return Container(
    margin: FxSpacing.top(16),
    child: InkWell(
      onTap: () {
        Navigator.push(
          context!,
          MaterialPageRoute(
            builder: (context) => MemberStatisticsPage(
              memberName: name,
              attendanceDates: [
                DateTime(2023, 1, 2),
                DateTime(2023, 1, 9),
                DateTime(2023, 1, 16),
                DateTime(2023, 1, 23),
                DateTime(2023, 1, 30),
                DateTime(2023, 2, 6),
                DateTime(2023, 2, 13),
                DateTime(2023, 2, 20),
                DateTime(2023, 2, 27),
                DateTime(2023, 3, 6),
                DateTime(2023, 3, 13),
                DateTime(2023, 3, 20),
                DateTime(2023, 3, 27),
                DateTime(2023, 4, 3),
                DateTime(2023, 4, 10),
                DateTime(2023, 4, 17),
                DateTime(2023, 4, 24),
                DateTime(2023, 5, 1),
                DateTime(2023, 5, 8),
                DateTime(2023, 5, 15),
                DateTime(2023, 5, 22),
                DateTime(2023, 5, 29),
                DateTime(2023, 6, 5),
                DateTime(2023, 6, 12),
                DateTime(2023, 6, 19),
                DateTime(2023, 6, 26),
                DateTime(2023, 7, 3),
                DateTime(2023, 7, 10),
                DateTime(2023, 7, 17),
                DateTime(2023, 7, 24),
                DateTime(2023, 7, 31),
                DateTime(2023, 8, 7),
                DateTime(2023, 8, 14),
                DateTime(2023, 8, 21),
                DateTime(2023, 8, 28),
                DateTime(2023, 9, 4),
                DateTime(2023, 9, 11),
                DateTime(2023, 9, 18),
                DateTime(2023, 9, 25),
                DateTime(2023, 10, 2),
                DateTime(2023, 10, 9),
                DateTime(2023, 10, 16),
                DateTime(2023, 10, 23),
                DateTime(2023, 10, 30),
                DateTime(2023, 11, 6),
                DateTime(2023, 11, 13),
                DateTime(2023, 11, 20),
                DateTime(2023, 11, 27),
                DateTime(2023, 12, 4),
                DateTime(2023, 12, 11),
                DateTime(2023, 12, 18),
                DateTime(2023, 12, 25),
              ],
              attendanceData: [
                true,
                false,
                true,
                true,
                false,
                true,
                true,
                false,
                true,
                false,
                true,
                false,
                true,
                true,
                false,
                true,
                true,
                false,
                true,
                false,
                true,
                false,
                true,
                true,
                false,
                true,
                true,
                false,
                true,
                false,
                true,
                false,
                true,
                true,
                false,
                true,
                true,
                false,
                true,
                false,
                true,
                false,
                true,
                true,
                false,
                true,
                true,
                false,
                true,
              ],
            ),
          ),
        );
      },
      child: Row(
        children: <Widget>[
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                child: Image(
                  image: AssetImage(image),
                  height: 44,
                  width: 44,
                  fit: BoxFit.cover,
                ),
              ),
              if (isActive)
                Positioned(
                  bottom: 1,
                  right: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                )
            ],
          ),
          Expanded(
            child: Container(
              margin: FxSpacing.left(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FxText.bodyLarge(
                    name,
                    color: Colors.black,
                    fontWeight: 600,
                  ),
                  FxText.bodySmall(
                    status,
                    fontSize: 12,
                    color: Colors.black.withAlpha(160),
                    fontWeight: 600,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          FxContainer(
            padding: FxSpacing.fromLTRB(8, 4, 8, 4),
            borderRadiusAll: 4,
            border: Border.all(color: Colors.grey, width: 1),
            color: Colors.transparent,
            child: Row(
              children: List.generate(
                attendanceData.length,
                (index) => Icon(
                  attendanceData[index] ? Icons.check_circle : Icons.cancel,
                  color: attendanceData[index] ? Colors.green : Colors.red,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

List<DateTime> getAttendanceDates(List<bool> attendanceData) {
  final now = DateTime.now();
  final attendanceDates = <DateTime>[];

  for (int i = 0; i < attendanceData.length; i++) {
    final date = now.subtract(Duration(days: i));
    if (attendanceData[i]) {
      attendanceDates.add(date);
    }
  }

  return attendanceDates;
}
