import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class CallController extends GetxController {
  final String appId;
  final String channelName;
  final String? token;

  CallController({
    required this.appId,
    required this.channelName,
    this.token,
  });

  RtcEngine? engine;

  // Reactive states
  var remoteUid = RxnInt();
  var localUserJoined = false.obs;
  var isMuted = false.obs;
  var isVideoDisabled = false.obs;
  var isSpeakerEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initAgora();
  }

  Future<void> _initAgora() async {
    await [Permission.microphone, Permission.camera].request();

    engine = createAgoraRtcEngine();
    await engine!.initialize(
      RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          localUserJoined.value = true;
        },
        onUserJoined: (RtcConnection connection, int uid, int elapsed) {
          remoteUid.value = uid;
        },
        onUserOffline: (RtcConnection connection, int uid,
            UserOfflineReasonType reason) {
          remoteUid.value = null;
        },
      ),
    );

    await engine!.enableVideo();
    await engine!.startPreview();
    await engine!.joinChannel(
      token: token ?? "",
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
      ),
    );
  }

  Future<void> leaveChannel() async {
    await engine?.leaveChannel();
    await engine?.release();
    Get.back();
  }

  Future<void> toggleMute() async {
    isMuted.value = !isMuted.value;
    await engine?.muteLocalAudioStream(isMuted.value);
  }

  Future<void> toggleVideo() async {
    isVideoDisabled.value = !isVideoDisabled.value;
    await engine?.muteLocalVideoStream(isVideoDisabled.value);
  }

  Future<void> switchCamera() async {
    await engine?.switchCamera();
  }

  Future<void> toggleSpeaker() async {
    isSpeakerEnabled.value = !isSpeakerEnabled.value;
    await engine?.setEnableSpeakerphone(isSpeakerEnabled.value);
  }

  @override
  void onClose() {
    engine?.leaveChannel();
    engine?.release();
    super.onClose();
  }
}
