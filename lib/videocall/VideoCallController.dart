// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_aws_chime/models/join_info.model.dart';
//
// class CallController extends GetxController {
//   var isLoading = false.obs;
//   var joinInfo = Rxn<JoinInfo>();
//
//   Future<void> createOrJoinMeeting(String userName) async {
//     try {
//       isLoading.value = true;
//
//       // Call your backend REST API that returns MeetingInfo + AttendeeInfo
//       final resp = await http.post(
//         Uri.parse("https://your-backend.com/create-meeting"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"name": userName}),
//       );
//
//       if (resp.statusCode == 200) {
//         final data = jsonDecode(resp.body);
//         final meetingInfo = MeetingInfo.fromJson(data["MeetingInfo"]);
//         final attendeeInfo = AttendeeInfo.fromJson(data["AttendeeInfo"]);
//         joinInfo.value = JoinInfo(meetingInfo, attendeeInfo);
//       } else {
//         Get.snackbar("Error", "Failed to create meeting: ${resp.body}");
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
