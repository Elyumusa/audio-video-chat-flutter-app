import 'package:audio_video_call_flutter_app/common/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'controller.dart';

class VoiceCallPage extends GetView<VoiceCallController> {
  const VoiceCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary_bg,
      body: SafeArea(
        child: Obx(() => Container(
              child: Stack(
                children: [
                  Positioned(
                      top: 10.h,
                      left: 30.w,
                      right: 30.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              "${controller.state.callTime.value}",
                              style: TextStyle(
                                  color: AppColors.primaryElementText,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          Container(
                            height: 70.h,
                            width: 70.h,
                            margin: EdgeInsets.only(top: 150.h),
                            child:
                                Image.asset("assets/images/account_header.png"),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 5.h),
                              child: Text(
                                "${controller.state.to_name.value}",
                                style: TextStyle(
                                    color: AppColors.primaryElementText,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.normal),
                              )),
                        ],
                      )),
                  Positioned(
                      bottom: 80.h,
                      left: 30.w,
                      right: 30.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //Microphone section
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.all(15.w),
                                  height: 60.w,
                                  width: 60.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.w),
                                      color: controller.state.openMic.value
                                          ? AppColors.primaryElementText
                                          : AppColors.primaryText),
                                  child: controller.state.openMic.value
                                      ? Image.asset(
                                          "assets/icons/b_microphone.png")
                                      : Image.asset(
                                          "assets/icons/a_microphone.png"),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10.h),
                                child: Text(
                                  "Microphone",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.primaryElementText,
                                      fontSize: 12.sp),
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: controller.state.isJoined.value
                                    ? controller.leaveChannel
                                    : controller.joinChannel,
                                child: Container(
                                  padding: EdgeInsets.all(15.w),
                                  height: 60.w,
                                  width: 60.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.w),
                                      color: controller.state.isJoined.value
                                          ? AppColors.primaryElementBg
                                          : AppColors.primaryElementStatus),
                                  child: controller.state.isJoined.value
                                      ? Image.asset("assets/icons/b_phone.png")
                                      : Image.asset(
                                          "assets/icons/a_telephone.png"),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10.h),
                                child: Text(
                                  controller.state.isJoined.value
                                      ? "Disconnect"
                                      : "Connect",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.primaryElementText,
                                      fontSize: 12.sp),
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.all(15.w),
                                  height: 60.w,
                                  width: 60.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.w),
                                      color:
                                          controller.state.enablespeaker.value
                                              ? AppColors.primaryElementText
                                              : AppColors.primaryText),
                                  child: controller.state.enablespeaker.value
                                      ? Image.asset(
                                          "assets/icons/b_trumpet.png")
                                      : Image.asset(
                                          "assets/icons/a_trumpet.png"),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10.h),
                                child: Text(
                                  "Speaker",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.primaryElementText,
                                      fontSize: 12.sp),
                                ),
                              )
                            ],
                          )
                        ],
                      ))
                ],
              ),
            )),
      ),
    );
  }
}
