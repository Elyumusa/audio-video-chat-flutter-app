import 'package:audio_video_call_flutter_app/pages/frame/welcome/controller.dart';
import 'package:get/get.dart';

import 'controller.dart';

class SignInBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(() => SignInController());
    // TODO: implement dependencies
  }
}
