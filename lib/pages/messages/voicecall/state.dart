import 'package:get/get.dart';

class VoiceCallstate {
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
}
