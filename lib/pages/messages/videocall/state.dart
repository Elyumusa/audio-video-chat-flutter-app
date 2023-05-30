import 'package:get/get.dart';

class VideoCallstate {
  RxBool isJoined = false.obs;
  RxBool openMic = true.obs;
  RxBool enablespeaker = true.obs;
  RxString callTime = "00.00".obs;
  RxString callstatus = "not connected".obs;

  var to_token = "".obs;
  var to_name = "".obs;
  var to_avatar = "".obs;
  var doc_id = "".obs;
  //receiver audience
  //anchor is the caller
  var call_role = "audience".obs;
  var channelId = "".obs;
  RxBool isReadyPreview = false.obs;
  //if user did not join show avatar, otherwise don't show
  RxBool isShowAvatar = true.obs;
  //change camera front and back
  RxBool switchCamera = true.obs;
  //remember remote id of the user from Agora
  RxInt onRemoteUID = 0.obs;
}
