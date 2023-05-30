import "dart:convert";

import "package:agora_rtc_engine/agora_rtc_engine.dart";
import "package:audio_video_call_flutter_app/common/apis/apis.dart";
import "package:audio_video_call_flutter_app/common/entities/chat.dart";
import "package:audio_video_call_flutter_app/common/routes/routes.dart";
import "package:audio_video_call_flutter_app/common/store/store.dart";
import "package:audio_video_call_flutter_app/common/values/server.dart";
import "package:audio_video_call_flutter_app/pages/frame/profile/state.dart";
import "package:audio_video_call_flutter_app/pages/messages/videocall/state.dart";
import "package:audio_video_call_flutter_app/pages/messages/voicecall/state.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:crypto/crypto.dart";
import "package:flutter/material.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:get/get.dart";
import "package:just_audio/just_audio.dart";
import "package:permission_handler/permission_handler.dart";

class VideoCallController extends GetxController {
  VideoCallController();
  final title = "Chat .";
  final state = VideoCallstate();
  final player = AudioPlayer();
  String appId = APPID;
  final db = FirebaseFirestore.instance;
  final profile_token = UserStore.to.profile.token;
  late final RtcEngine engine;
  ChannelProfileType channelProfileType =
      ChannelProfileType.channelProfileCommunication;
  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;
    state.to_name.value = data['to_name'] ?? "";
    state.to_avatar.value = data['to_avatar'] ?? "";
    state.call_role.value = data['call_role'] ?? "";
    state.doc_id.value = data['doc_id'] ?? "";
    state.to_token.value = data['to_token'] ?? "";
    print("...your name id is ${state.to_name.value}");
    initEngine();
  }

  Future<void> initEngine() async {
    await player.setAsset("assets/moo.mp3");
    await getToken();
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    engine.registerEventHandler(RtcEngineEventHandler(
      onError: (err, msg) {
        print("[onError] error: $err, ,msg:$msg");
      },
      onJoinChannelSuccess: (connection, elapsed) {
        print("onConnection ${connection.toJson()}");
        state.isJoined.value = true;
      },
      onUserJoined: (connection, remoteUid, elapsed) async {
        state.onRemoteUID.value = remoteUid;
        //since the other user joined, don't show the avatar anymore
        state.isShowAvatar.value = false;
        await player.pause();
      },
      onLeaveChannel: (connection, stats) {
        print("user left the room.......===== ${stats.toJson()}");
        state.isJoined.value = false;
        state.onRemoteUID.value = 0;
        state.isShowAvatar.value = true;
      },
      onRtcStats: (connection, stats) {
        print("time====${stats.duration}");
      },
    ));
    await engine.enableVideo();
    await engine.setVideoEncoderConfiguration(const VideoEncoderConfiguration(
        dimensions: VideoDimensions(height: 360, width: 640),
        frameRate: 15,
        bitrate: 0));
    await engine.startPreview();
    state.isReadyPreview.value = true;

    await joinChannel();
    if (state.call_role == "anchor") {
      //send notification to the other user
      await sendNotification("video");
      await player.play();
    }
  }

  Future<void> sendNotification(String call_type) async {
    CallRequestEntity callRequestEntity = CallRequestEntity();
    callRequestEntity.call_type = call_type;
    callRequestEntity.to_token = state.to_token.value;
    callRequestEntity.to_avatar = state.to_avatar.value;
    callRequestEntity.doc_id = state.doc_id.value;
    callRequestEntity.to_name = state.to_name.value;
    print("The other user's token is ${state.to_token.value}");
    var res = await ChatAPI.call_notifications(params: callRequestEntity);
    if (res.code == 0) {
      print("success");
    } else {
      print("Could not sent notifications");
    }
  }

  Future<String> getToken() async {
    if (state.call_role == "anchor") {
      state.channelId.value = md5
          .convert(utf8.encode("${profile_token}_${state.to_token}"))
          .toString();
    } else {
      state.channelId.value = md5
          .convert(utf8.encode("${state.to_token}_${profile_token}"))
          .toString();
    }
    CallTokenRequestEntity callTokenRequestEntity = CallTokenRequestEntity();
    callTokenRequestEntity.channel_name = state.channelId.value;
    print("...channel id is ${state.channelId.value}");
    print("...my access token is ${UserStore.to.token}");
    print("The other user's token is ${state.to_token.value}");
    var res = await ChatAPI.call_token(params: callTokenRequestEntity);
    if (res.code == 0) {
      return res.data!;
    }
    return "";
  }

  Future<void> joinChannel() async {
    await Permission.microphone.request();
    await [Permission.microphone, Permission.camera].request();
    EasyLoading.show(
        indicator: CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);
    print("It has joined the channel");
    String token = await getToken();
    if (token.isEmpty) {
      EasyLoading.dismiss();
      Get.back();
      return;
    }
    await engine.joinChannel(
        token: token,
        //"007eJxTYBD2VRF3mjRFWLfX6GDg10+23S/j5yl2qj5ylt0066JDr68CQ5KRgWWimYmRmalFsoklEKSZJRqbpyUnmpkapyWaJj6845XSEMjIkLHpOBMjAwSC+MIMZZkpqfm6iaUpmfm6aTmlJSWpRQwMALt1JGg=",
        channelId: state.channelId.value, //"video-audio-flutter",
        uid: 0,
        options: ChannelMediaOptions(
            channelProfile: channelProfileType,
            clientRoleType: ClientRoleType.clientRoleBroadcaster));
    EasyLoading.dismiss();
  }

  Future leaveChannel() async {
    EasyLoading.show(
      indicator: CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );
    await player.pause();
    await sendNotification("cancel");
    state.isJoined.value = false;
    state.switchCamera.value = true;

    EasyLoading.dismiss();
    Get.back();
  }

  Future switchCamera() async {
    await engine.switchCamera();
    state.switchCamera.value = !state.switchCamera.value;
  }

  Future<void> _dispose() async {
    await player.pause();
    await engine.leaveChannel();
    await engine.release();
    await player.stop();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    _dispose();
    super.onClose();
  }

  @override
  void dispose() {
    // TODO: implement disposeId
    _dispose();
    super.dispose();
  }
}
