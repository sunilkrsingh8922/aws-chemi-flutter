import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aws_chime/models/join_info.model.dart';
import 'package:flutter_aws_chime/views/meeting.view.dart';

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
    return SafeArea(
      child: SafeArea(
        child: Scaffold(
          body: callData == null? CircularProgressIndicator():
          MeetingView(
            JoinInfo(
              MeetingInfo.fromJson({
                'MeetingId':
                    widget.meetingId ?? '92faba56-cd9b-40b3-9058-43b1d62a2713',
                'ExternalMeetingId': 'Public',
                'MediaRegion': callData!['Meeting']['MediaRegion']??
                    'us-east-1',
                'MediaPlacement': {
                  "AudioFallbackUrl": callData!['Meeting']['MediaPlacement']['AudioFallbackUrl']??
                      "wss://wss.k.m1.ue1.app.chime.aws:443/calls/92faba56-cd9b-40b3-9058-43b1d62a2713",
                  "AudioHostUrl":callData!['Meeting']['MediaPlacement']['AudioHostUrl']??
                      "18b67e825ac86732baad9dd44cea29c8.k.m1.ue1.app.chime.aws:3478",
                  "EventIngestionUrl":callData!['Meeting']['MediaPlacement']['EventIngestionUrl']??
                      "https://data.svc.ue1.ingest.chime.aws/v1/client-events",
                  "ScreenDataUrl":callData!['Meeting']['MediaPlacement']['ScreenDataUrl']??
                      "wss://bitpw.m1.ue1.app.chime.aws:443/v2/screen/92faba56-cd9b-40b3-9058-43b1d62a2713",
                  "ScreenSharingUrl":callData!['Meeting']['MediaPlacement']['ScreenSharingUrl']??
                      "wss://bitpw.m1.ue1.app.chime.aws:443/v2/screen/92faba56-cd9b-40b3-9058-43b1d62a2713",
                  "ScreenViewingUrl":callData!['Meeting']['MediaPlacement']['ScreenViewingUrl']??
                      "wss://bitpw.m1.ue1.app.chime.aws:443/ws/connect?passcode=null&viewer_uuid=null&X-BitHub-Call-Id=92faba56-cd9b-40b3-9058-43b1d62a2713",
                  "SignalingUrl":callData!['Meeting']['MediaPlacement']['SignalingUrl']??
                      "wss://signal.m1.ue1.app.chime.aws/control/92faba56-cd9b-40b3-9058-43b1d62a2713",
                  "TurnControlUrl":callData!['Meeting']['MediaPlacement']['TurnControlUrl']??
                      "https://2713.cell.us-east-1.meetings.chime.aws/v2/turn_sessions",
                },
                'MeetingFeatures': {
                  "Attendee": {"MaxCount": 3},
                  "Audio": {"EchoReduction": "AVAILABLE"},
                  "Video": {"MaxResolution": "HD"},
                },
                'MeetingArn':callData!['Meeting']['MeetingArn']??
                    'arn:aws:chime:us-east-1:476057873255:meeting/92faba56-cd9b-40b3-9058-43b1d62a2713',
                'TenantIds': [],
              }),
              callData!['atendee'] !=null
              ?AttendeeInfo.fromJson({
                "AttendeeId": callData!['atendee']['AttendeeId']??
                    "9e8636ee-cec4-4517-99e2-39e5da3522f1",
                "ExternalUserId": widget.userName ?? "Guest",
                "JoinToken": callData!['atendee']['JoinToken']??
                    "OWU4NjM2ZWUtY2VjNC00NTE3LTk5ZTItMzllNWRhMzUyMmYxOjdiN2Y4OWY3LWExYjAtNDNhZi05YjUxLTZhNTJkOGY3NzBlZA",
              }):AttendeeInfo.fromJson({
                "AttendeeId":"",
                "ExternalUserId":"",
                "JoinToken":""
              }),
            ),
          ),
        ),
      ),
    );
  }
}
