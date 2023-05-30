import "package:audio_video_call_flutter_app/common/routes/routes.dart";
import "package:audio_video_call_flutter_app/pages/frame/profile/state.dart";
import "package:get/get.dart";

class WelcomeController extends GetxController {
  WelcomeController();
  final title = "Chat .";
  final state = Profilestate();

  @override
  void onReady() {
    super.onReady();
    Future.delayed(
        Duration(seconds: 3), () => Get.offAllNamed(AppRoutes.Message));
  }
}
