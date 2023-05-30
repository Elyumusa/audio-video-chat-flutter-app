import 'package:audio_video_call_flutter_app/common/entities/entities.dart';
import 'package:get/get.dart';

class Messagestate {
  var head_detail = UserItem().obs;
  RxBool tabstatus = true.obs;
  RxList<Message> msgList = <Message>[].obs;
}
