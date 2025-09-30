
import 'package:flutter/material.dart';
import 'package:flutter_aws_chime/models/join_info.model.dart';
import 'package:flutter_aws_chime/views/meeting.view.dart';

class VideoCallPage extends StatefulWidget {
  final dynamic meeting;
  final dynamic attendee;
  const VideoCallPage({super.key, required this.meeting, required this.attendee});

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {

  @override
  Widget build(BuildContext context) {
    if (widget.meeting == null || widget.attendee == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            MeetingView(
              JoinInfo(
                MeetingInfo.fromJson(widget.meeting),
                AttendeeInfo.fromJson(widget.attendee),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

