import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aws_chime/models/join_info.model.dart';
import 'package:flutter_aws_chime/views/meeting.view.dart';

class VideoCallPage extends StatefulWidget {
  final dynamic meeting;
  final dynamic atendee;
  const VideoCallPage({super.key, this.meeting,this.atendee});

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {

  @override
  void initState() {
    super.initState();
  }
  static const platform = MethodChannel('flutter_aws_chime');

  Future<void> leaveMeeting() async {
    try {
      await platform.invokeMethod('leaveMeeting');
    } catch (e) {
      debugPrint("Leave meeting failed: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
    // ✅ If your plugin provides cleanup methods, call them here.
    try {
      leaveMeeting();   // Some forks expose a static leave()
      // Or MeetingView.end(); if available
    } catch (e) {
      debugPrint("Error while leaving meeting: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.meeting == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: Scaffold(
        body: MeetingView(
          JoinInfo(
            MeetingInfo.fromJson(widget.meeting),
              AttendeeInfo.fromJson(widget.atendee[0]),
          ),
        ),
      ),
    );
  }
}
