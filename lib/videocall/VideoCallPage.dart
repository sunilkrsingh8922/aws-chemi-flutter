
import 'package:flutter/material.dart';
// import 'package:flutter_aws_chime/models/join_info.model.dart';
// import 'package:flutter_aws_chime/views/meeting.view.dart';

class VideoCallPage extends StatefulWidget {
  final dynamic meeting;

  VideoCallPage({this.meeting});
  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SafeArea(
        child: Scaffold(
          body: widget.meeting['Meeting'] == null && widget.meeting['Attendee'] == null ? CircularProgressIndicator():
          MeetingView(
            JoinInfo(
              MeetingInfo.fromJson(widget.meeting['Meeting']),
              AttendeeInfo.fromJson(widget.meeting['Attendee'])
            ),
          ),
        ),
      ),
    );
  }
}
