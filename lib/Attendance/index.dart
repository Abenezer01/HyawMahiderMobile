import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'dart:math';
import './add.dart';

class AttendanceViewScreen extends StatefulWidget {
  const AttendanceViewScreen({super.key});

  @override
  _AttendanceViewScreenState createState() => _AttendanceViewScreenState();
}

class _AttendanceViewScreenState extends State<AttendanceViewScreen> {
  List<String> studentList = [
    'Student 1',
    'Student 2',
    'Student 3',
    // Add more student names as per your requirement
  ];
  Map<String, List<bool>> attendanceData = {};

  @override
  void initState() {
    super.initState();
    _initializeAttendanceData();
  }

  void _initializeAttendanceData() {
    attendanceData.clear();
    for (String student in studentList) {
      List<bool> studentAttendance = [];
      // Generate sample attendance data for the last five days
      for (int i = 0; i < 5; i++) {
        // Randomly assign true or false to represent attendance
        bool isPresent = Random().nextBool();
        studentAttendance.add(isPresent);
      }
      attendanceData[student] = studentAttendance;
    }
  }

  Future<void> _navigateToTakeAttendance() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => TakeAttendanceScreen()));

    FxControllerStore.resetStore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: FxSpacing.fromLTRB(24, 0, 24, 0),
          child: ListView.builder(
            itemCount: studentList.length,
            itemBuilder: (context, index) {
              String student = studentList[index];
              List<bool> studentAttendance = attendanceData[student] ?? [];

              return memberItem(
                image: './assets/images/profile/avatar_1.jpg',
                index: index,
                name: student,
                status: 'Status',
                attendanceData: studentAttendance,
              );
            },
          )),
      floatingActionButton: SizedBox(
        width: 40,
        height: 40,
        child: ElevatedButton(
          onPressed: _navigateToTakeAttendance,
          child: Icon(Icons.add, size: 20),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
}) {
  return Container(
      margin: FxSpacing.top(16),
      child: InkWell(
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
              padding: FxSpacing.fromLTRB(16, 8, 16, 8),
              borderRadiusAll: 4,
              border: Border.all(color: Colors.grey, width: 1),
              color: Colors.transparent,
              child: Row(
                children: List.generate(
                  attendanceData.length,
                  (index) => Icon(
                    attendanceData[index] ? Icons.check_circle : Icons.cancel,
                    color: attendanceData[index] ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ));
}
