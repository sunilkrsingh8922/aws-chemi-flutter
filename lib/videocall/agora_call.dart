import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../controller/agora_call_controller.dart';

class AgoraCall extends StatelessWidget {
  final String appId;
  final String channelName;
  final String? token;

  const AgoraCall({
    super.key,
    required this.appId,
    required this.channelName,
    this.token,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      CallController(appId: appId, channelName: channelName, token: token),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Video View
            Obx(() {
              final remoteUid = controller.remoteUid.value;
              final localUserJoined = controller.localUserJoined.value;
              final isVideoDisabled = controller.isVideoDisabled.value;

              return Stack(
                children: [
                  Center(
                    child: remoteUid != null
                        ? AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: controller.engine!,
                        canvas: VideoCanvas(uid: remoteUid),
                        connection: RtcConnection(
                          channelId: channelName,
                        ),
                      ),
                    )
                        : Container(
                      color: Colors.grey.shade900,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_outline,
                                size: 120, color: Colors.grey.shade700),
                            const SizedBox(height: 20),
                            Text(
                              'Waiting for others to join...',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (localUserJoined)
                    Positioned(
                      top: 40,
                      right: 16,
                      child: GestureDetector(
                        onTap: controller.switchCamera,
                        child: Container(
                          width: 120,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: isVideoDisabled
                                ? const Center(
                              child: Icon(Icons.videocam_off,
                                  color: Colors.white, size: 40),
                            )
                                : AgoraVideoView(
                              controller: VideoViewController(
                                rtcEngine: controller.engine!,
                                canvas: const VideoCanvas(uid: 0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }),

            // Control Buttons
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlButton(
                    icon: controller.isMuted.value
                        ? Icons.mic_off
                        : Icons.mic,
                    isActive: !controller.isMuted.value,
                    onPressed: controller.toggleMute,
                  ),
                  _buildControlButton(
                    icon: controller.isVideoDisabled.value
                        ? Icons.videocam_off
                        : Icons.videocam,
                    isActive: !controller.isVideoDisabled.value,
                    onPressed: controller.toggleVideo,
                  ),
                  // End Call
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.red,
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: controller.leaveChannel,
                        customBorder: const CircleBorder(),
                        child: Container(
                          width: 70,
                          height: 70,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.call_end,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buildControlButton(
                    icon: Icons.flip_camera_ios,
                    isActive: true,
                    onPressed: controller.switchCamera,
                  ),
                  _buildControlButton(
                    icon: controller.isSpeakerEnabled.value
                        ? Icons.volume_up
                        : Icons.volume_off,
                    isActive: controller.isSpeakerEnabled.value,
                    onPressed: controller.toggleSpeaker,
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isActive,
    Color? activeColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: isActive
            ? (activeColor ?? Colors.blue)
            : Colors.grey.withOpacity(0.4),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
