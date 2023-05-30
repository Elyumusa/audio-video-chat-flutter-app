import "dart:io";

import "package:audio_video_call_flutter_app/common/apis/apis.dart";
import "package:audio_video_call_flutter_app/common/entities/entities.dart";
import "package:audio_video_call_flutter_app/common/routes/routes.dart";
import "package:audio_video_call_flutter_app/common/store/store.dart";
import "package:audio_video_call_flutter_app/common/widgets/toast.dart";
import "package:audio_video_call_flutter_app/pages/frame/welcome/state.dart";
import "package:audio_video_call_flutter_app/pages/messages/chat/state.dart";
import "package:audio_video_call_flutter_app/pages/messages/state.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:get/get.dart";
import "package:image_picker/image_picker.dart";
import "package:permission_handler/permission_handler.dart";

class ChatController extends GetxController {
  ChatController();
  final state = Chatstate();
  late String doc_id;
  void goMore() {
    state.more_status.value = state.more_status.value ? false : true;
  }

  ScrollController myscrollController = ScrollController();
  final myInputController = TextEditingController();
//Get the user/sender's token
  final token = UserStore.to.profile.token;
  final db = FirebaseFirestore.instance;
  var listener;
  var isLoadmore = true;
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  void audioCall() {
    state.more_status.value = false;
    Get.toNamed(AppRoutes.VoiceCall, parameters: {
      "to_name": state.to_name.value,
      "to_avatar": state.to_avatar.value,
      "call_role": "anchor",
      "to_token": state.to_token.value,
      "doc_id": doc_id
    });
  }

  Future requestPermission(Permission permission) async {
    var permissionstatus = await permission.status;
    if (permissionstatus != PermissionStatus.granted) {
      var status = await permission.request();
      if (status != PermissionStatus.granted) {
        toastInfo(msg: "Please enable permission to have a video call");
        if (GetPlatform.isAndroid) {
          await openAppSettings();
        }
        return false;
      }
    }
    return true;
  }

  void videoCall() async {
    state.more_status.value = false;
    bool micstatus = await requestPermission(Permission.microphone);
    bool camstatus = await requestPermission(Permission.camera);
    if (GetPlatform.isAndroid && micstatus && camstatus) {
      Get.toNamed(AppRoutes.VideoCall, parameters: {
        "to_name": state.to_name.value,
        "to_avatar": state.to_avatar.value,
        "call_role": "anchor",
        "to_token": state.to_token.value,
        "doc_id": doc_id
      });
    } else {
      Get.toNamed(AppRoutes.VideoCall, parameters: {
        "to_name": state.to_name.value,
        "to_avatar": state.to_avatar.value,
        "call_role": "anchor",
        "to_token": state.to_token.value,
        "doc_id": doc_id
      });
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    var data = Get.parameters;
    print("data incoming: $data");
    doc_id = data['doc_id']!;
    state.to_token.value = data['to_token'] ?? "";
    state.to_name.value = data['to_name'] ?? "";
    state.to_avatar.value = data['to_avatar'] ?? "";
    state.to_online.value = data['to_online'] ?? "1";
    //Clearing red dots
    clearMsgNum(doc_id);
  }

  void clearMsgNum(String doc_id) async {
    var messageResult = await db.collection("message").doc(doc_id).get();
    if (messageResult.data() != null) {
      var item = messageResult.data()!;
      int to_msg_num = item['to_msg_num'] == null ? 0 : item['to_msg_num'];
      int from_msg_num =
          item['from_msg_num'] == null ? 0 : item['from_msg_num'];
      //this is your phone
      if (item['from_token'] == token) {
        to_msg_num = 0;
      } else {
        from_msg_num = 0;
      }
      await db.collection("message").doc(doc_id).update({
        "to_msg_num": to_msg_num,
        "from_msg_num": from_msg_num,
      });
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    print("This is onReady");
    state.msgcontentList.clear();
    final messages = db
        .collection("message")
        .doc(doc_id)
        .collection("msgList")
        .withConverter(
          fromFirestore: Msgcontent.fromFirestore,
          toFirestore: (value, options) => value.toFirestore(),
        )
        .orderBy("addtime", descending: true)
        .limit(15);
    listener = messages.snapshots().listen((event) {
      List<Msgcontent> tempMsgList = <Msgcontent>[];
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            if (change.doc.data() != null) {
              tempMsgList.add(change.doc.data()!);
              print("${change.doc.data()!}");
              print("...added ${myInputController.text}");
            }
            break;
          case DocumentChangeType.modified:
            break;
          case DocumentChangeType.removed:
            break;
        }
      }
      tempMsgList.reversed.forEach((element) {
        state.msgcontentList.value.insert(0, element);
      });
      state.msgcontentList.refresh();
      if (myscrollController.hasClients) {
        myscrollController.animateTo(
            //Points to the very top of your list
            //lowest index
            myscrollController.position.minScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut);
      }
    });
    myscrollController.addListener(() {
      if (myscrollController.offset + 10 >
          myscrollController.position.maxScrollExtent) {
        if (isLoadmore) {
          state.isLoading.value = true;
          //to stop unnecessary request to firebase
          isLoadmore = false;
          asyncLoadMoreData();
        }
      }
    });
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadFile();
    } else {
      print("No image selected");
    }
  }

  Future uploadFile() async {
    var result = await ChatAPI.upload_img(file: _photo);
    print(result.data);
    if (result.code == 0) {
      sendImageMessage(result.data!);
    } else {
      toastInfo(msg: "sending image error");
    }
  }

  Future sendImageMessage(String url) async {
    //Created an object to send to firebase
    final content = Msgcontent(
        token: token, content: url, type: "text", addtime: Timestamp.now());
    await db
        .collection("message")
        .doc(doc_id)
        .collection("msgList")
        .withConverter(
          fromFirestore: Msgcontent.fromFirestore,
          toFirestore: (value, options) {
            return value.toFirestore();
          },
        )
        .add(content)
        .then((docRef) {
      print("...base id is ${doc_id}....new image doc id is ${docRef.id}");
    });
    var messageResult = await db
        .collection("message")
        .doc(doc_id)
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (value, options) => value.toFirestore(),
        )
        .get();
    if (messageResult.data() != null) {
      var item = messageResult.data()!;
      int to_msg_num = item.to_msg_num == null ? 0 : item.to_msg_num!;
      int from_msg_num = item.from_msg_num == null ? 0 : item.from_msg_num!;
      if (item.from_token == token) {
        from_msg_num += 1;
      } else {
        to_msg_num += to_msg_num;
      }
      await db.collection("message").doc(doc_id).update({
        "to_msg_num": to_msg_num,
        "from_msg_num": from_msg_num,
        "last_msg": "【image】",
        "last_time": Timestamp.now().toDate().toIso8601String()
      });
    }
  }

  void closeAllPop() async {
    Get.focusScope?.unfocus();
    state.more_status.value = false;
  }

  void asyncLoadMoreData() async {
    final messages = await db
        .collection("message")
        .doc(doc_id)
        .collection("msgList")
        .withConverter(
          fromFirestore: Msgcontent.fromFirestore,
          toFirestore: (value, options) {
            return value.toFirestore();
          },
        )
        .orderBy("addtime", descending: true)
        .where("addtime", isLessThan: state.msgcontentList.value.last.addtime)
        .limit(10)
        .get();
    if (messages.docs.isNotEmpty) {
      messages.docs.forEach((element) {
        var data = element.data();
        state.msgcontentList.value.add(data);
      });
    }
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      isLoadmore = true;
    });
    state.isLoading.value = false;
  }

  void sendMessage() async {
    String sendContent = myInputController.text;
    if (sendContent.isEmpty) {
      toastInfo(msg: "Content is empty");
      return;
    } else {
      //Created an object to send to firebase
      final content = Msgcontent(
          token: token,
          content: sendContent,
          type: "text",
          addtime: Timestamp.now());
      await db
          .collection("message")
          .doc(doc_id)
          .collection("msgList")
          .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (value, options) {
              return value.toFirestore();
            },
          )
          .add(content)
          .then((docRef) {
        print("...base id is ${doc_id}....new message doc id is ${docRef.id}");
        myInputController.clear();
      });
      var messageResult = await db
          .collection("message")
          .doc(doc_id)
          /*.withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (value, options) => value.toFirestore(),
          )*/
          .get();
      if (messageResult.data() != null) {
        var item = messageResult.data()!;
        int to_msg_num = item['to_msg_num'] == null ? 0 : item['to_msg_num'];
        int from_msg_num =
            item['from_msg_num'] == null ? 0 : item['from_msg_num']!;
        if (item['from_token'] == token) {
          from_msg_num += 1;
        } else {
          to_msg_num += to_msg_num;
        }
        await db.collection("message").doc(doc_id).update({
          "to_msg_num": to_msg_num,
          "from_msg_num": from_msg_num,
          "last_msg": sendContent,
          "last_time": Timestamp.now().toDate().toIso8601String()
        });
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
    listener.cancel();
    myInputController.dispose();
    myscrollController.dispose();
    clearMsgNum(doc_id);
  }
}
