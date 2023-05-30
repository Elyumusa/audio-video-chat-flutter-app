import 'package:audio_video_call_flutter_app/common/values/colors.dart';
import 'package:audio_video_call_flutter_app/pages/messages/chat/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'chat_left_list.dart';
import 'chat_right_list.dart';

class ChatList extends GetView<ChatController> {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: AppColors.primaryBackground,
          padding: EdgeInsets.only(bottom: 70.h),
          child: GestureDetector(
            onTap: () {
              controller.closeAllPop();
            },
            child: CustomScrollView(
              controller: controller.myscrollController,
              reverse: true,
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 0.w),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                          childCount: controller.state.msgcontentList.length,
                          (context, index) {
                    var item = controller.state.msgcontentList[index];
                    if (controller.token == item.token) {
                      return ChatRightList(item);
                    }
                    return ChatLeftList(item);
                  })),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 0.w),
                  sliver: SliverToBoxAdapter(
                    child: controller.state.isLoading.value
                        ? Align(
                            alignment: Alignment.center,
                            child: Text("Loading...."),
                          )
                        : Container(),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
