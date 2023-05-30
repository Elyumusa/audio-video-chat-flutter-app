import "package:audio_video_call_flutter_app/common/routes/routes.dart";
import "package:audio_video_call_flutter_app/common/store/user.dart";
import "package:audio_video_call_flutter_app/pages/frame/profile/state.dart";
import "package:get/get.dart";
import "package:google_sign_in/google_sign_in.dart";

class ProfileController extends GetxController {
  ProfileController();
  final title = "Chat .";
  final state = Profilestate();

  @override
  void onInit() {
    super.onInit();
    var userItem = Get.arguments;
    if (userItem != null) {
      state.profile_detail.value = userItem;
    }
  }

  void goLogout() async {
    await GoogleSignIn().signOut();
    await UserStore.to.onLogout();
  }
}
