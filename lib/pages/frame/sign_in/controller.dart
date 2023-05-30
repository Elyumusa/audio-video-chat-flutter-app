import "dart:convert";

import "package:audio_video_call_flutter_app/common/apis/apis.dart";
import "package:audio_video_call_flutter_app/common/entities/entities.dart";
import "package:audio_video_call_flutter_app/common/routes/routes.dart";
import "package:audio_video_call_flutter_app/common/store/store.dart";
import "package:audio_video_call_flutter_app/common/utils/http.dart";
import "package:audio_video_call_flutter_app/common/widgets/toast.dart";
import "package:audio_video_call_flutter_app/pages/frame/sign_in/index.dart";
import "package:audio_video_call_flutter_app/pages/frame/welcome/state.dart";
import "package:flutter/material.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:get/get.dart";
import "package:google_sign_in/google_sign_in.dart";

class SignInController extends GetxController {
  SignInController();
  final state = SignInState();

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ["openid"]);

  void handleSignIn(String type) async {
    try {
      if (type == "phone number") {
      } else if (type == "google") {
        var user = await _googleSignIn.signIn();
        if (user != null) {
          String? displayName = user.displayName;
          String email = user.email;
          String id = user.id;
          String photoUrl = user.photoUrl ?? "";
          LoginRequestEntity loginPanelListRequestEntity = LoginRequestEntity();
          loginPanelListRequestEntity.avatar =
              photoUrl.isEmpty ? "photo" : photoUrl;
          loginPanelListRequestEntity.name = displayName;
          loginPanelListRequestEntity.email = email;
          loginPanelListRequestEntity.open_id = id;
          loginPanelListRequestEntity.type = 2;
          print(jsonEncode(loginPanelListRequestEntity));
          asyncPostAllData(loginPanelListRequestEntity);
        }
      }
    } catch (e) {
      print("====error with login: $e");
    }
  }

  asyncPostAllData(LoginRequestEntity loginRequestEntity) async {
    //UserStore.to.setIsLogin = true;
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);
    var result = await UserAPI.Login(params: loginRequestEntity);
    if (result.code == 0) {
      await UserStore.to.saveProfile(result.data!);
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      toastInfo(msg: "Internet Error");
    }
    Get.offAllNamed(AppRoutes.Message);
  }
}
