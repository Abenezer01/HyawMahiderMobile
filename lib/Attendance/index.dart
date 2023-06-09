import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:http/http.dart' as http;
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
      MaterialPageRoute(builder: (context) => TakeAttendanceScreen()),
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
