import 'package:audio_video_call_flutter_app/common/entities/entities.dart';
import 'package:get/get.dart';

class Chatstate {
  RxList<Msgcontent> msgcontentList = <Msgcontent>[].obs;
  var to_token = "".obs;
  var to_name = "".obs;
  var to_avatar = "".obs;
  var to_online = "".obs;
  RxBool more_status = false.obs;
  RxBool isLoading = false.obs;
}
