import "package:audio_video_call_flutter_app/common/apis/contact.dart";
import "package:audio_video_call_flutter_app/common/entities/entities.dart";
import "package:audio_video_call_flutter_app/common/routes/routes.dart";
import "package:audio_video_call_flutter_app/common/store/user.dart";
import "package:audio_video_call_flutter_app/pages/contact/index.dart";
import "package:audio_video_call_flutter_app/pages/frame/profile/state.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:get/get.dart";

class ContactController extends GetxController {
  ContactController();
  final state = Contactstate();
  final token = UserStore.to.profile.token;
  final db = FirebaseFirestore.instance;
  @override
  void onReady() async {
    super.onReady();
    asyncLoadAllData();
  }

  goChat(ContactItem item) async {
    var from_messages = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("from_token", isEqualTo: token)
        .where("to_token", isEqualTo: item.token)
        .get();
    print("=====from messages==${from_messages.docs.isEmpty}");
    var to_messages = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("from_token", isEqualTo: item.token)
        .where("to_token", isEqualTo: token)
        .get();
    print("=====from messages==${to_messages.docs.isEmpty}");
    if (from_messages.docs.isEmpty && to_messages.docs.isEmpty) {
      var profile = UserStore.to.profile;
      var msgdata = Msg(
          from_token: profile.token,
          to_token: item.token,
          from_name: profile.name,
          from_avatar: profile.avatar,
          to_avatar: item.avatar,
          to_name: item.name,
          from_online: profile.online,
          to_online: item.online,
          last_msg: "",
          //last_time: Timestamp.now().toDate().toIso8601String(),
          msg_num: 0);
      var doc_id = await db
          .collection("message")
          .withConverter(
              fromFirestore: Msg.fromFirestore,
              toFirestore: (Msg msg, options) {
                return msg.toFirestore();
              })
          .add(msgdata);
      doc_id.update({"last_time": Timestamp.now().toDate().toIso8601String()});
      Get.toNamed("/chat", parameters: {
        'doc_id': doc_id.id,
        "to_token": item.token ?? "",
        "to_name": item.name ?? "",
        "to_avatar": item.avatar ?? "",
        "to_online": item.online.toString()
      });
    } else {
      if (from_messages.docs.isNotEmpty) {
        Get.toNamed("/chat", parameters: {
          'doc_id': from_messages.docs.first.id,
          "to_token": item.token ?? "",
          "to_name": item.name ?? "",
          "to_avatar": item.avatar ?? "",
          "to_online": item.online.toString()
        });
      }
      if (to_messages.docs.isNotEmpty) {
        Get.toNamed("/chat", parameters: {
          'doc_id': to_messages.docs.first.id,
          "to_token": item.token ?? "",
          "to_name": item.name ?? "",
          "to_avatar": item.avatar ?? "",
          "to_online": item.online.toString()
        });
      }
    }
  }

  asyncLoadAllData() async {
    EasyLoading.show(
        indicator: CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);
    state.contactList.clear();
    var result = await ContactAPI.post_contact();
    if (kDebugMode) print(result.data!);
    if (result.code == 0) {
      state.contactList.addAll(result.data!);
    }
    EasyLoading.dismiss();
  }
}
