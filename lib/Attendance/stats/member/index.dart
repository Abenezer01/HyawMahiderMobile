import 'package:flutter/material.dart';
import 'package:hyaw_mahider/Attendance/add.dart';
import 'package:intl/intl.dart';
import 'package:hyaw_mahider/services/api-service.dart';
import 'dart:convert';
import 'package:hyaw_mahider/models/member.dart';

class MemberStatisticsPage extends StatefulWidget {
  final String memberId;

  const MemberStatisticsPage({
    required this.memberId,
  });

  @override
  State<MemberStatisticsPage> createState() => _MemberStatisticsPageState();
}

class _MemberStatisticsPageState extends State<MemberStatisticsPage> {
  Member member = {} as Member;
  Future<List<bool?>> getSingleAttendance() async {
    APIService apiService = APIService();
    final data = await apiService.getData(
      '/auth/members-module/attendance/get-member-attendance/year?year=2023&member_id=' +
          widget.memberId,
    );

    Map<String, dynamic> response = json.decode(data);
    List<dynamic> responseList = response['data'] as List<dynamic>;
    Map<String, dynamic> memberProfile =
        response['member'] as Map<String, dynamic>;

    setState(() {
      member = Member.fromMap(memberProfile);
    });

    List<bool?> attendanceList = [];
    for (var value in responseList) {
      if (value == null) {
        attendanceList.add(null);
      } else if (value is bool) {
        attendanceList.add(value);
      }
    }

    return attendanceList;
  }

  List<bool?> attendanceData = [];

  @override
  void initState() {
    super.initState();
    fetchAttendanceData();
  }

  Future<void> fetchAttendanceData() async {
    try {
      final data = await getSingleAttendance();
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
      appBar: AppBar(
        title: Text('Member Attendance'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: attendanceData.isNotEmpty
            ? Column(
                children: [
                  Text('Attendance Statistics'),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 10,
                        childAspectRatio:
                            1.0, // Set aspect ratio to make items square
                        crossAxisSpacing: 8.0, // Add spacing between columns
                        mainAxisSpacing: 8.0, // Add spacing between rows
                      ),
                      itemCount: 52,
                      itemBuilder: (context, index) {
                        final attendanceIndex =
                            attendanceData.length > index ? index : 0;
                        final attendance = attendanceData[attendanceIndex];
                        final weekNumber = index + 1;

                        return Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: attendance == true
                                ? Colors.lightGreen
                                : Colors.redAccent,
                            shape: BoxShape.rectangle,
                          ),
                          child: Text(
                            weekNumber.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Center(
                child: Text('No attendance data available'),
              ),
      ),
    );
  }
}
