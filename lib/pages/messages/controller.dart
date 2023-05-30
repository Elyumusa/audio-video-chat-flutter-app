import "package:audio_video_call_flutter_app/common/apis/apis.dart";
import "package:audio_video_call_flutter_app/common/entities/base.dart";
import "package:audio_video_call_flutter_app/common/entities/entities.dart";
import "package:audio_video_call_flutter_app/common/routes/routes.dart";
import "package:audio_video_call_flutter_app/common/store/store.dart";
import "package:audio_video_call_flutter_app/pages/frame/welcome/state.dart";
import "package:audio_video_call_flutter_app/pages/messages/state.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:get/get.dart";

class MessageController extends GetxController {
  MessageController();
  final state = Messagestate();
  final db = FirebaseFirestore.instance;
  final token = UserStore.to.profile.token;
  void goProfile() async {
    await Get.toNamed(AppRoutes.Profile, arguments: state.head_detail.value);
  }

  goTabstatus() {
    EasyLoading.show(
        indicator: CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);
    state.tabstatus.value = !state.tabstatus.value;
    if (state.tabstatus.value) {
      asyncLoadMsgData();
    } else {}
    EasyLoading.dismiss();
  }

  void asyncLoadMsgData() async {
    var from_messages = await db
        .collection("message")
        /*.withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (value, options) {
            return value.toFirestore();
          },
        )*/
        .where("from_token", isEqualTo: token)
        .get();
    print(from_messages.docs.length);
    var to_messages = await db
        .collection("message")
        /*.withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (value, options) {
            return value.toFirestore();
          },
        )*/
        .where("to_token", isEqualTo: token)
        .get();
    print(to_messages.docs.length);

    state.msgList.clear();
    if (from_messages.docs.isNotEmpty) {
      await addMessage(from_messages.docs);
    }
    if (to_messages.docs.isNotEmpty) {
      await addMessage(to_messages.docs);
    }
  }

  addMessage(List<QueryDocumentSnapshot<Map>> data) {
    data.forEach((element) {
      Map item = element.data();
      Message message = Message();
      message.doc_id = element.id;
      print(" damn ${item}");
      message.last_time = Timestamp.fromDate(
          DateTime.parse(item['last_time'])); //item.last_time;
      message.msg_num = item['msg_num'];
      message.last_msg = item['last_msg'];
      if (item['from_token'] == token) {
        message.name = item['to_name'];
        message.avatar = item['to_avatar'];
        message.token = item['to_token'];
        message.online = item['to_online'];
        message.msg_num = item['to_msg_num'] ?? 0;
      } else {
        message.name = item['from_name'];
        message.avatar = item['from_avatar'];
        message.token = item['from_token'];
        message.online = item['from_online'];
        message.msg_num = item['from_msg_num'] ?? 0;
      }
      print(
          "object boss last message: ${item['last_msg']!} L_time: ${item['last_time']} mg_num:  ${item['msg_num']} ");
      state.msgList.add(message);
    });
  }

  @override
  void onReady() {
    super.onReady();
    firebaseMessageSetup();
  }

  @override
  void onInit() {
    super.onInit();
    getProfile();
    _snapshots();
  }

  _snapshots() {
    var token = UserStore.to.profile.token;
    final toMessageRef = db
        .collection("message")
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (value, options) {
            return value.toFirestore();
          },
        )
        .where("to_token", isEqualTo: token);
    final fromMessageRef = db
        .collection("message")
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (value, options) {
            return value.toFirestore();
          },
        )
        .where("from_token", isEqualTo: token);
    toMessageRef.snapshots().listen((event) {
      asyncLoadMsgData();
    });
    fromMessageRef.snapshots().listen((event) {
      asyncLoadMsgData();
    });
  }

  void getProfile() async {
    var profile = await UserStore.to.profile;
    state.head_detail.value = profile;
    state.head_detail.refresh();
  }

  firebaseMessageSetup() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print("====This is my device token: $fcmToken");
    if (fcmToken != null) {
      BindFcmTokenRequestEntity bindFcmTokenRequestEntity =
          BindFcmTokenRequestEntity();
      bindFcmTokenRequestEntity.fcmtoken = fcmToken;
      await ChatAPI.bind_fcmtoken(params: bindFcmTokenRequestEntity);
    }
  }

  void goContactPage() async {
    await Get.toNamed(AppRoutes.Contact);
  }
}
