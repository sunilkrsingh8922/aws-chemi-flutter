<<<<<<< HEAD
=======
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_aws_chime/models/join_info.model.dart';
// import 'package:flutter_aws_chime/views/meeting.view.dart';
>>>>>>> 0034d9ae7750a5cac3f2a1c185879d0a28ecf91f

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
<<<<<<< HEAD
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
=======
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Call'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              CircularProgressIndicator()
            else if (error != null)
              Column(
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error: $error', textAlign: TextAlign.center),
                ],
              )
            else
              Column(
                children: [
                  Icon(Icons.videocam, size: 64, color: Colors.blue),
                  SizedBox(height: 16),
                  Text('Video Call Ready', style: TextStyle(fontSize: 24)),
                  SizedBox(height: 8),
                  Text('Meeting ID: ${widget.meetingId ?? "N/A"}'),
                  SizedBox(height: 8),
                  Text('User: ${widget.userName ?? "Guest"}'),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement video call functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Video call functionality temporarily disabled')),
                      );
                    },
                    child: Text('Start Call'),
                  ),
                ],
              ),
          ],
>>>>>>> 0034d9ae7750a5cac3f2a1c185879d0a28ecf91f
        ),
      ),
    );
  }
}
