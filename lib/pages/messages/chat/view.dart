import 'package:audio_video_call_flutter_app/common/values/colors.dart';
import 'package:audio_video_call_flutter_app/pages/frame/welcome/controller.dart';
import 'package:audio_video_call_flutter_app/pages/messages/chat/widgets/chat_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'controller.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primarySecondaryBackground,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 20.w),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 44.w,
                height: 44.h,
                child: CachedNetworkImage(
                  imageUrl: controller.state.to_avatar.value,
                  errorWidget: (context, url, error) {
                    return const Image(
                      image: AssetImage("assets/images/account_header.png"),
                    );
                  },
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.w),
                          image: DecorationImage(image: imageProvider)),
                    );
                  },
                ),
              ),
              Positioned(
                  bottom: 5.w,
                  right: 0.w,
                  height: 14.w,
                  child: Container(
                    width: 14.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                        color: controller.state.to_online.value == "1"
                            ? AppColors.primaryElementStatus
                            : AppColors.primarySecondaryElementText,
                        borderRadius: BorderRadius.circular(12.w),
                        border: Border.all(
                            width: 2, color: AppColors.primaryElementText)),
                  ))
            ],
          ),
        )
      ],
      title: Obx(() {
        return Container(
          child: Text(
            "${controller.state.to_name}",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                fontFamily: "Avenir",
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
                fontSize: 16.sp),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() {
        return SafeArea(
            child: Stack(
          children: [
            ChatList(),
            Positioned(
                bottom: 0.h,
                child: Container(
                  width: 360.w,
                  padding: EdgeInsets.only(left: 20.w, bottom: 10.h),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 270.w,
                          padding: EdgeInsets.only(
                              top: 10.h, bottom: 10.h, left: 5.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.w),
                              color: AppColors.primaryBackground,
                              border: Border.all(
                                  color: AppColors.primaryElementText)),
                          child: Row(children: [
                            Container(
                              width: 220.w,
                              child: TextField(
                                maxLines: null,
                                controller: controller.myInputController,
                                keyboardType: TextInputType.multiline,
                                autofocus: false,
                                decoration: InputDecoration(
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    hintStyle: const TextStyle(
                                        color: AppColors
                                            .primarySecondaryElementText),
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    disabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    hintText: "Message...",
                                    contentPadding: EdgeInsets.only(
                                        left: 15.w, top: 0, bottom: 0)),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.sendMessage();
                              },
                              child: Container(
                                width: 40.w,
                                height: 40.w,
                                child: Image.asset("assets/icons/send.png"),
                              ),
                            )
                          ]),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.goMore();
                          },
                          child: Container(
                            height: 40.w,
                            width: 40.w,
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                                color: AppColors.primaryElement,
                                borderRadius: BorderRadius.circular(40.w),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: Offset(1, 1))
                                ]),
                            child: Image.asset("assets/icons/add.png"),
                          ),
                        ),
                      ]),
                )),
            controller.state.more_status.value
                ? Positioned(
                    right: 20.w,
                    bottom: 70.h,
                    height: 200.h,
                    width: 40.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.w),
                                color: AppColors.primaryBackground,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: Offset(1, 1))
                                ]),
                            height: 40.h,
                            width: 40.h,
                            child: Image.asset("assets/icons/file.png"),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.imgFromGallery();
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.w),
                                color: AppColors.primaryBackground,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: Offset(1, 1))
                                ]),
                            height: 40.h,
                            width: 40.h,
                            child: Image.asset("assets/icons/photo.png"),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.audioCall();
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.w),
                                color: AppColors.primaryBackground,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: Offset(1, 1))
                                ]),
                            height: 40.h,
                            width: 40.h,
                            child: Image.asset("assets/icons/call.png"),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.videoCall();
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.w),
                                color: AppColors.primaryBackground,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: Offset(1, 1))
                                ]),
                            height: 40.h,
                            width: 40.h,
                            child: Image.asset("assets/icons/video.png"),
                          ),
                        )
                      ],
                    ))
                : Container()
          ],
        ));
      }),
    );
  }
}
