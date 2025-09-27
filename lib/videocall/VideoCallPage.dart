import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_aws_chime/models/join_info.model.dart';
// import 'package:flutter_aws_chime/views/meeting.view.dart';

import '../services/ChimeService.dart';

class VideoCallPage extends StatefulWidget {
  final String? userName;
  final String? meetingId;

  VideoCallPage({this.userName, this.meetingId});

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  Map<String, dynamic>? callData; // Holds API response
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    // TODO: implement initState
    _initCall();
    super.initState();
  }
  Future<void> _initCall() async {
    try {
      final token = await FirebaseMessaging.instance.getToken(); if (token == null || token.isEmpty) { throw Exception('FCM token unavailable'); }
      final data = await ChimeService.initiateCall(
        name: widget.userName ?? "Guest",
        fcmToken: token ?? "",
        metingId: widget.meetingId!
      );

      if (!mounted) return; // 👈 Prevent setState after dispose

      setState(() {
        callData = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return; // 👈 Prevent setState after dispose

      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
        ),
      ),
    );
  }
}
